require 'isbm2_adaptor_rest/ext/client_common'
require 'isbm_adaptor_common'
require 'nokogiri'
require 'yaml'

module ISBMRestAdaptor
  # ConsumerRequest adaptor implementation that translates the common 
  # interface into the OpenAPI REST implementation.
  # 
  # Where an operation may raise [ArgumentError|ParameterFault], an ArgumentError 
  # will be raised if client-side validation is enabled, otherwise a ParameterFault 
  # is raised if the server-side validation fails.
  class ConsumerRequest < ConsumerRequestServiceApi
    include ClientCommon

    # Creates a new ISBM ConsumerRequest client.
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

    # Opens a consumer request session for a channel for posting requests and
    # reading responses.
    #
    # @param uri [String] the channel URI
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @option options [String] :listener_url the URL for notification callbacks
    # @return [String] the session id
    # @raise [ArgumentError|ParameterFault] if uri is blank
    # @raise [ChannelFault] if the channel URI does not exist
    # @raise [OperationFault] if the channel type is not of type 'Request'
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def open_session(uri, options = {})
      options = {listener_url: nil}.merge(options)
      session = create_session(uri, options[:listener_url])
      data, _status_code, _headers = open_consumer_request_session_with_http_info(uri, session: session)
      data.session_id
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::ChannelFault, fault_message if e.code == 404
      raise IsbmAdaptor::OperationFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Posts a request message on a channel.
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
    # @param content [String|Hash|Object] a valid XML/JSON string, a Hash, or Object that 
    #   can be serialized as XML or JSON
    # @param topic [String] the topic
    # @param expiry [Duration] when the message should expire
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [String] the request message id (TODO: should this return a Message object?) 
    # @raise [ArgumentError|ParameterFault] if session_id, content or topic are blank, or
    #   content is not valid XML/JSON
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def post_request(session_id, content, topic, expiry = nil, options = {})
      message = create_message(content, topic, expiry)
      data, _status_code, _headers = post_request_with_http_info(session_id, message: message)
      data.message_id
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Expires a posted request message.
    #
    # @param session_id [String] the session id used to post the request
    # @param message_id [String] the message id received after posting the request
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if session_id or message_id are blank
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def expire_request(session_id, message_id, options = {})
      expire_request_with_http_info(session_id, message_id, options)
      nil
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Returns the first response message, if any, in the message queue
    # associated with the request.
    #
    # @param session_id [String] the session id
    # @param request_message_id [String] the id of the original request message
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [IsbmAdaptor::Message] the first message in the queue for the session
    #   associated with the request. nil if no message.
    # @raise [ArgumentError|ParameterFault] if session_id or request_message_id are blank
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def read_response(session_id, request_message_id, options = {})
      data, _status_code, _headers = read_response_with_http_info(session_id, request_message_id, options)
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

    # Deletes the first response message, if any, in the message queue
    # associated with the request.
    #
    # @param session_id [String] the session id
    # @param request_message_id [String] the id of the original request message
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if session_id or request_message_id are blank
    # @raise [SessionFault] if the session id does not exist or is not a request type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def remove_response(session_id, request_message_id, options = {})
      remove_response_with_http_info(session_id, request_message_id, options)
      nil
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Closes a consumer request session.
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

    def create_session(uri, listener_url = nil)
      listener_url = nil if listener_url.blank?

      session = ISBMRestAdaptor::Session.new(topics: nil, listener_url: listener_url, filter_expressions: nil)
      raise ArgumentError, session.list_invalid_properties.join(', ') if client_side_validation? && !session.valid?
      session
    end

    def create_message(content, topic, expiry)
      message_content = build_message_content(content)
      topics = [topic].flatten.reject(&:'blank?')
      raise ArgumentError, 'invalid value for "topic", must have exactly 1 topic' if client_side_validation? && topics.size > 1

      expiry = expiry.blank? ? nil : expiry.to_s
      message = Message.new(message_content: message_content, topics: topics, expiry: expiry)
      raise ArgumentError, message.list_invalid_properties.join(', ') if client_side_validation? && !message.valid?

      message
    end
  end
end
