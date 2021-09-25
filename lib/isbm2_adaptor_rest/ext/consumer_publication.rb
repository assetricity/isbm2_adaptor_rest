require 'isbm2_adaptor_rest/ext/client_common'
require 'isbm_adaptor_common'
require 'nokogiri'
require 'yaml'

module ISBMRestAdaptor
  # ConsumerPublication adaptor implementation that translates the common 
  # interface into the OpenAPI REST implementation.
  # 
  # Where an operation may raise [ArgumentError|ParameterFault], an ArgumentError 
  # will be raised if client-side validation is enabled, otherwise a ParameterFault 
  # is raised if the server-side validation fails.
  class ConsumerPublication < ConsumerPublicationServiceApi
    include ClientCommon

    # Creates a new ISBM ConsumerPublication client.
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
      if config = options[:client_config]
        super(ApiClient.new(config))
      else
        super()
      end
    end

    # Opens a subscription session for a channel.
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
    # @raise [OperationFault] if the channel type is not of type 'Publication'
    # @raise [NamespaceFault] if the same namespace prefix is assigned different namespace names
    # @raise [UnknownFault] if an unknown or unexpected error occurs
  def open_session(uri, topics, options = {})
      options = {listener_url: nil, filter_expression: []}.merge(options)
      session = create_session(uri, topics, options[:listener_url], options[:filter_expression])
      data, _status_code, _headers = open_subscription_session_with_http_info(uri, session: session)
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

    # Reads the first message, if any, in the session queue.
    #
    # @param session_id [String] the session id
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [IsbmAdaptor::Message] first message in session queue. nil if no message.
    # @raise [ArgumentError|ParameterFault] if session_id is blank
    # @raise [SessionFault] if the session id does not exist or is not a publication type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def read_publication(session_id, options = {})
      data, _status_code, _headers = read_publication_with_http_info(session_id, options)
      IsbmAdaptor::Message.new(data.message_id, 
        convert_message_content(data.message_content), 
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

    # Removes the first message, if any, in the session queue.
    #
    # @param session_id [String] the session id
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if session_id is blank
    # @raise [SessionFault] if the session id does not exist or is not a publication type
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def remove_publication(session_id, options = {})
      remove_publication_with_http_info(session_id, options)
      nil
    rescue ApiError => e
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 422
      raise IsbmAdaptor::UnknownFault
    end

    # Closes a subscription session.
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
      fault_message = YAML.safe_load(e.response_body)['fault']
      raise IsbmAdaptor::ParameterFault, fault_message if e.code == 400
      raise IsbmAdaptor::SessionFault, fault_message if e.code == 404
      raise IsbmAdaptor::UnknownFault
    end

    private

    def convert_message_content(message_content)
      if message_content.content.is_a?(String) && !message_content.content_encoding
        return YAML.safe_load(message_content.content) if media_type_json?(message_content.media_type)
        return Nokogiri::XML(message_content.content) if media_type_xml?(message_content.media_type)
      end
      message_content.content
    end

    def create_session(uri, topics, listener_url = nil, filter_expressions = [])
      validate_presence_of topics, 'Topics' if client_side_validation? # underlying validation does not necessarily catch this

      topics = [topics].flatten.reject(&:'blank?')
      listener_url = nil if listener_url.blank?
      filter_expressions = [filter_expressions].flatten.map {|fe| create_filter_expression(fe) }.reject(&:'nil?')

      session = ISBMRestAdaptor::Session.new(topics: topics, listener_url: listener_url, filter_expressions: filter_expressions)
      raise ArgumentError, session.list_invalid_properties.join(', ') if client_side_validation? && !session.valid?
      session
    end

    def create_filter_expression(options)
      expression_string = ISBMRestAdaptor::FilterExpressionExpressionString.new(
        expression: options[:expression], 
        language: options[:language], 
        language_version: options[:language_version]
      )
      raise ArgumentError, expression_string.list_invalid_properties.join(', ') if client_side_validation? && !expression_string.valid?

      namespaces = [options[:namespaces]].flatten.map { |ns| ns.map { |prefix, name| ISBMRestAdaptor::Namespace.new(prefix: prefix, name: name) }.first }
      filter_expression = ISBMRestAdaptor::FilterExpression.new(
        expression_string: expression_string, 
        applicable_media_types: options[:applicable_media_types], 
        namespaces: namespaces
      )
      raise ArgumentError, filter_expression.list_invalid_properties.join(', ') if client_side_validation? && !filter_expression.valid?

      validate_namespaces(filter_expression.namespaces) if client_side_validation?

      filter_expression
    end

    def validate_namespaces(namespaces)
      return unless namespaces
      prefixes = {}
      namespaces.each do |ns|
        if prefixes.key?(ns.prefix) && prefixes[ns.prefix] != ns.name
          raise IsbmAdaptor::NamespaceFault, "Prefix #{ns.prefix} has more than one assigned namespace name" 
        end
        prefixes[ns.prefix] = ns.name
      end
    end
  end
end
