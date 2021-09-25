require 'isbm_adaptor_common'
require 'isbm2_adaptor_rest/ext/client_common'

module ISBMRestAdaptor
  # ChannelManagement adaptor implementation that translates the common 
  # interface into the OpenAPI REST implementation.
  # 
  # Where an operation may raise [ArgumentError|ParameterFault], an ArgumentError 
  # will be raised if client-side validation is enabled, otherwise a ParameterFault 
  # is raised if the server-side validation fails.
  class ChannelManagement < ChannelManagementApi
    include ClientCommon

    # Creates a new ISBM ChannelManagement client.
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

    # Creates a new channel.
    #
    # @param uri [String] the channel URI
    # @param type [Symbol|String] the channel type, either `publication or `request` (symbol or titleized string)
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @option options [String] :description the channel description, defaults to nil
    # @option options [Array<Object>] :tokens list of valid security tokens, e.g., username password pairs [['u1', 'p1'], ['u2', 'p2']]
    # @return [IsbmAdaptor::Channel]
    # @raise [ArgumentError|ParameterFault] if uri or type are blank or type is not a valid Channel Type
    # @raise [ChannelFault] if the channel URI already exists
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def create_channel(uri, type, options = {})
      channel_type = convert_type(type)
      security_tokens = convert_tokens(options[:tokens])
      channel_parameter = create_channel_input(uri, channel_type, options[:description], security_tokens)
      data, _status_code, _headers = create_channel_with_http_info(channel: channel_parameter)
      IsbmAdaptor::Channel.new(data.uri, data.channel_type, data.description)
    rescue ApiError => e
      raise IsbmAdaptor::ParameterFault, YAML.safe_load(e.response_body)['fault'] if e.code == 400
      raise IsbmAdaptor::ChannelFault, YAML.safe_load(e.response_body)['fault'] if e.code == 409
      raise IsbmAdaptor::UnknownFault
    end
    
    # Adds security tokens to a channel.
    #
    # @param uri [String] the channel URI
    # @param tokens [Array<Object>] list of valid security tokens, e.g., username password pairs [['u1', 'p1'], ['u2', 'p2']]
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if uri is blank or no tokens are provided
    # @raise [ChannelFault] if the channel URI already exists
    # @raise [OperationFault] if adding security tokens to the channel is disallowed
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def add_security_tokens(uri, tokens = [], options = {})
      security_tokens = convert_tokens(tokens) || []
      opts = options.merge(security_tokens: security_tokens)
      add_security_tokens_with_http_info(uri, opts)
      nil
    rescue ApiError => e
      raise IsbmAdaptor::ParameterFault, YAML.safe_load(e.response_body)['fault'] if e.code == 400
      raise IsbmAdaptor::ChannelFault, YAML.safe_load(e.response_body)['fault'] if e.code == 404
      raise IsbmAdaptor::OperationFault, YAML.safe_load(e.response_body)['fault'] if e.code == 409
      raise IsbmAdaptor::UnknownFault
    end
    
    # Removes security tokens from a channel.
    #
    # @param uri [String] the channel URI
    # @param tokens [Array<Object>] list of valid security tokens, e.g., username password pairs [['u1', 'p1'], ['u2', 'p2']]
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if uri is blank or no tokens are provided
    # @raise [ChannelFault] if the channel URI already exists
    # @raise [SecurityTokenFault] if any of the security tokens are invalid
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def remove_security_tokens(uri, tokens = [], options = {})
      security_tokens = convert_tokens(tokens) || []
      opts = options.merge(security_tokens: security_tokens)
      remove_security_tokens_with_http_info(uri, opts)
      nil
    rescue ApiError => e
      raise IsbmAdaptor::ParameterFault, YAML.safe_load(e.response_body)['fault'] if e.code == 400
      raise IsbmAdaptor::ChannelFault, YAML.safe_load(e.response_body)['fault'] if e.code == 404
      raise IsbmAdaptor::SecurityTokenFault, YAML.safe_load(e.response_body)['fault'] if e.code == 409
      raise IsbmAdaptor::UnknownFault
    end
    
    # Deletes the specified channel.
    #
    # @param uri [String] the channel URI
    # @param options [Hash] local options (TODO, e.g., auth overrides)
    # @return [void]
    # @raise [ArgumentError|ParameterFault] if uri is blank
    # @raise [ChannelFault] if the channel URI does not exist
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def delete_channel(uri, options = {})
      delete_channel_with_http_info(uri, options)
      nil
    rescue ApiError => e
      raise IsbmAdaptor::ParameterFault, YAML.safe_load(e.response_body)['fault'] if e.code == 400
      raise IsbmAdaptor::ChannelFault, YAML.safe_load(e.response_body)['fault'] if e.code == 404
      raise IsbmAdaptor::UnknownFault
    end
    
    # Gets information about the specified channel.
    #
    # @param uri [String] the channel URI
    # @param options [Hash] local options (TODO, e.g., auth overrides)
    # @return [Channel] the queried channel
    # @raise [ArgumentError|ParameterFault] if uri is blank
    # @raise [ChannelFault] if the channel URI does not exist
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def get_channel(uri, options = {})
      data, _status_code, _headers = get_channel_with_http_info(uri, options)
      IsbmAdaptor::Channel.new(data.uri, data.channel_type, data.description)
    rescue ApiError => e
      raise IsbmAdaptor::ParameterFault, YAML.safe_load(e.response_body)['fault'] if e.code == 400
      raise IsbmAdaptor::ChannelFault, YAML.safe_load(e.response_body)['fault'] if e.code == 404
      raise IsbmAdaptor::UnknownFault
    end
    
    # Gets information about all (authorized) channels.
    #
    # @option options [nil] local options (TODO, e.g., auth overrides)
    # @return [Array<Channel>] all authorized channels on the ISBM
    # @raise [UnknownFault] if an unknown or unexpected error occurs
    def get_channels(options = {})
      data, _status_code, _headers = get_channels_with_http_info(options)
      data.map do |c|
        IsbmAdaptor::Channel.new(c.uri, c.channel_type, c.description)
      end
    rescue ApiError => e
      raise IsbmAdaptor::UnknownFault
    end

    private

    def convert_type(type)
      return nil if type.blank?
      return type.to_s unless @api_client.config.client_side_validation
      return ChannelType.build_from_hash(type.to_s.downcase.capitalize)
    rescue
      raise ArgumentError, "#{type} is not a valid channel type. Must be Publication or Request."
    end

    def convert_tokens(tokens)
      return tokens if tokens.nil?
      tokens.map { |username, password| {username: username, password: password}  }
    end

    def create_channel_input(uri, channel_type, description, security_tokens)
      channel = Channel.new(uri: uri, channel_type: channel_type, description: description, security_tokens: security_tokens)
      raise ArgumentError, channel.list_invalid_properties.join(', ') if client_side_validation? && !channel.valid?
      channel
    end
  end
end
