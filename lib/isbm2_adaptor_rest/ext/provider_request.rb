require 'isbm2_adaptor_rest/ext/client_common'
require 'isbm_adaptor_common'
require 'nokogiri'
require 'yaml'

module ISBMRestAdaptor
  # ProviderRequest adaptor implementation that translates the common 
  # interface into the OpenAPI REST implementation.
  # 
  # Where an operation may raise [ArgumentError|ParameterFault], an ArgumentError 
  # will be raised if client-side validation is enabled, otherwise a ParameterFault 
  # is raised if the server-side validation fails.
  class ProviderRequest < ProviderRequestServiceApi
    include ClientCommon

    # Creates a new ISBM ProviderRequest client.
    #
    # The endpoint can be overridden if needing to target multiple ISBM instances 
    # from an application. Otherwise common configuration is preferred as the 
    # endpoint is often implementation specific.
    #
    # @param options [Hash] options to customise the client instance
    # @option options [String] :endpoint the endpoint URI
    # @option options [Object] :auth_token e.g., username and password, i.e. [username, password]
    # @option options [Object] :logger (Rails.logger or $stdout) location where log should be output
    # @option options [Boolean] :log (true) specify whether requests are logged
    # @option options [Boolean] :pretty_print (false) specify whether request and response contents are formatted
    # @option options [Object] :client_config implementation specific configuration for the client (mostly to support test independence)
    def initialize(options = {})
      # TODO: customise configuration provided to super(...) from the 'endpoint' and 'options' parameters
      # TODO: what other common configuration items might we want to be able to override here?
      if (config = options[:client_config])
        super(ApiClient.new(config))
      else
        super()
      end
    end

    # Opens a provider request session for a channel for reading requests and
    # posting responses.
    #
    # @param uri [String] the channel URI
    # @param topics [Array<String>, String] a collection of topics or single topic
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @option options [String] :listener_url the URL for notification callbacks
    # @option options [Array<Hash>, Hash] :filter_expression the filter expression(s) for 
    #   content-based filtering, for example, XPath or JSONPath expression: 
    #   { 
    #     expression: '/*', language: 'XPath', language_version: '1.0', 
    #     applicable_media_types: ['application/xml'], 
    #     namespaces: [{"xs" => "http://www.w3.org/2001/XMLSchema"}]
    #   }
    #   XPath expressions may include the prefixes and namespaces used by the XPath expression. 
    #   The hash key represents the namespace prefix while the value represents the namespace name.
    #   For example,
    #   [{"xs" => "http://www.w3.org/2001/XMLSchema"}, {"isbm" => "http://www.openoandm.org/xml/ISBM/"}]
    # @return [String] the session id
    # @raise [ArgumentError|ParameterFault] if uri or topics are blank
    # @raise [ChannelFault] if the channel URI does not exist
    # @raise [OperationFault] if the channel type is not of type 'Request'
    # @raise [NamespaceFault] if the same namespace prefix is assigned different namespace names
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def open_session(uri, topics, options = {})
      options = { listener_url: nil, filter_expression: [] }.merge(options)
      session = create_session(uri, topics, options[:listener_url], options[:filter_expression])
      data, _status_code, _headers = open_provider_request_session_with_http_info(uri, session: session)
      data.session_id
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      if e.code == 400 && fault_message =~ /namespace/i
        # Check for NamespaceFault, looks like ParameterFault
        session.filter_expressions.map(&:namespaces).each { |nms| validate_namespaces(nms) }
      end
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::ChannelFault, fault_message if e.code == 404
      raise IsbmAdaptor::OperationFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Returns the first request message in the message queue for the session.
    # Note: this service does not remove the message from the message queue.
    #
    # @param session_id [String] the session id
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [IsbmAdaptor::Message] the first message in the queue for the session.
    #   nil if no message.
    # @raise [ArgumentError|ParameterFault] if session_id is blank
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def read_request(session_id, options = {})
      data, _status_code, _headers = read_request_with_http_info(session_id, options)
      IsbmAdaptor::Message.new(data.message_id, 
        extract_message_content(data.message_content), 
        data.topics, 
        data.message_content.media_type, 
        data.message_content.content_encoding
      )
    rescue ApiError => e
      return nil if e.code == 404 # for REST path, cannot tell difference between no session and no message
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404 # for reference
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Deletes the first request message, if any, in the message queue for the session.
    #
    # @param session_id [String] the session id
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if session_id is blank
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def remove_request(session_id, options = {})
      remove_request_with_http_info(session_id, options)
      nil
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Posts a response message on a channel.
    #
    # The message content may be an XML or JSON string, a Hash specifying the
    # :media_type, :content_encoding (e.g., `base64`), and :content fields, or
    # an object that will be encoded to XML or JSON with `to_xml` or `to_json`,
    # respectively.
    #
    # The first form will attempt to guess if it is XML or JSON an configure
    # accordingly; if the type needs to be explicit use the second form.
    # If client-side validation is enabled, the XML or JSON string will be
    # validated for syntactic correctness.
    #
    # The second form can be used to provide plain text, binary content, etc.
    # Binary content must already be correctly encoded and the :content_encoding 
    # field must indicate the encoding used, most likely 'base64'.
    # If the specified :media_type is an XML or JSON type and it is not an encoded
    # string, the content will be validated for syntactic corrctness, unless 
    # client-side validation is disabled.
    #
    # If a Hash is provided, the second and third forms are differentiated by
    # whether the contains only the keys: :media_type, :content_encoding, and
    # :content. The :content_encoding field is optional.
    #
    # ```
    # {
    #  media_type: 'application/xml', 
    #  content_encoding: 'base64', 
    #  content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='
    # }
    # ```
    #
    # @param session_id [String] the session id
    # @param request_message_id [String] the id of the original request message
    # @param content [String|Hash|Object] a valid XML/JSON string, a Hash, or Object that 
    #   can be serialized as XML or JSON
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [String] the response message id (TODO: should this return a Message object?) 
    # @raise [ArgumentError|ParameterFault] if session_id, request_message_id, or content are 
    #   blank, or content is not valid XML/JSON
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def post_response(session_id, request_message_id, content, options = {})
      message = create_message(content)
      data, _status_code, _headers = post_response_with_http_info(session_id, request_message_id, message: message)
      data.message_id
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Closes a provider request session.
    #
    # @param session_id [String] the session id
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if session_id is blank
    # @raise [SessionFault] if the session id does not exist
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def close_session(session_id, options = {})
      close_session_with_http_info(session_id, options)
      nil
    rescue ApiError => e
      raise IsbmAdaptor::ParameterFault, YAML.safe_load(e.response_body)['fault'] if e.code == 400
      raise IsbmAdaptor::SessionFault, YAML.safe_load(e.response_body)['fault'] if e.code == 404
      raise IsbmAdaptor::UnknownFault
    end

    private

    def create_session(uri, topics, listener_url = nil, filter_expressions = [])
      # underlying validation does not necessarily catch this
      validate_presence_of topics, 'Topics' if client_side_validation?

      topics = [topics].flatten.reject(&:'blank?')
      listener_url = nil if listener_url.blank?
      filter_expressions = [filter_expressions].flatten.map { |fe| create_filter_expression(fe) }.reject(&:'nil?')

      session = ISBMRestAdaptor::Session.new(topics: topics, listener_url: listener_url, filter_expressions: filter_expressions)
      raise ArgumentError, session.list_invalid_properties.join(', ') if client_side_validation? && !session.valid?
      session
    end

    def create_message(content)
      message_content = build_message_content(content)
      message = Message.new(message_content: message_content)
      raise ArgumentError, message.list_invalid_properties.join(', ') if client_side_validation? && !message.valid?

      message
    end
  end
end
