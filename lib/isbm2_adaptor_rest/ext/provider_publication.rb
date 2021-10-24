require 'isbm2_adaptor_rest/ext/client_common'
require 'isbm_adaptor_common'
require 'nokogiri'
require 'yaml'

module IsbmRestAdaptor
  # ProviderPublication adaptor implementation that translates the common 
  # interface into the OpenAPI REST implementation.
  # 
  # Where an operation may raise [ArgumentError|ParameterFault], an ArgumentError 
  # will be raised if client-side validation is enabled, otherwise a ParameterFault 
  # is raised if the server-side validation fails.
  class ProviderPublication < ProviderPublicationServiceApi
    include ClientCommon

    # Creates a new ISBM ProviderPublication client.
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
    
    # Opens a publication session for a channel.
    #
    # @param uri [String] the channel URI
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [String] the session id
    # @raise [ArgumentError|ParameterFault] if uri is blank
    # @raise [ChannelFault] if the channel URI does not exist
    # @raise [OperationFault] if the channel type is not of type 'Publication'
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def open_session(uri, options = {})
      data, _status_code, _headers = open_publication_session_with_http_info(uri, options)
      data.session_id
    rescue ApiError => e
      fault_message = extract_fault_message(e.response_body)
      handle_channel_access_api_error(e.code, fault_message)
    end

    # Posts a publication message.
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
    # @param topics [Array<String>, String] a collection of topics or single topic
    # @param expiry [Duration] when the message should expire
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [String] the message id (TODO: should this return a Message object?) 
    # @raise [ArgumentError|ParameterFault] if session_id, content or topics are blank, or
    #   content is not valid XML/JSON
    # @raise [SessionFault] if the session id does not exist or is not a publication type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def post_publication(session_id, content, topics, expiry = nil, options = {})
      message = create_message(content, topics, expiry)
      data, _status_code, _headers = post_publication_with_http_info(session_id, message: message)
      data.message_id
    rescue ApiError => e
      fault_message = extract_fault_message(e.response_body)
      handle_session_access_api_error(e.code, fault_message)
    end

    # Expires a posted publication message.
    #
    # @param session_id [String] the session id used to post the publication
    # @param message_id [String] the message id received after posting the publication
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if session_id or message_id are blank
    # @raise [SessionFault] if the session id does not exist or is not a publication type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def expire_publication(session_id, message_id, options = {})
      expire_publication_with_http_info(session_id, message_id, options)
      nil
    rescue ApiError => e
      fault_message = extract_fault_message(e.response_body)
      handle_session_access_api_error(e.code, fault_message)
    end

    # Closes a publication session.
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
      fault_message = extract_fault_message(e.response_body)
      handle_session_access_api_error(e.code, fault_message)
    end
    
    private
    
    def create_message(content, topics, expiry)
      message_content = build_message_content(content)
      topics = [topics].flatten.reject(&:'blank?')
      expiry = expiry.blank? ? nil : expiry.to_s
      message = Message.new(message_content: message_content, topics: topics, expiry: expiry)
      raise ArgumentError, message.list_invalid_properties.join(', ') if client_side_validation? && !message.valid?
      message
    end
  end
end
