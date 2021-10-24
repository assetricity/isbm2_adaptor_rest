require 'isbm2_adaptor_rest/ext/client_common'
require 'isbm_adaptor_common'
require 'nokogiri'
require 'yaml'

module IsbmRestAdaptor
  # ConfigurationDiscovery adaptor implementation that translates the common 
  # interface into the OpenAPI REST implementation.
  # 
  # Where an operation may raise [ArgumentError|ParameterFault], an ArgumentError 
  # will be raised if client-side validation is enabled, otherwise a ParameterFault 
  # is raised if the server-side validation fails.
  class ConfigurationDiscovery < ConfigurationDiscoveryServiceApi
    include ClientCommon

    # Creates a new ISBM ConfigurationDiscovery client.
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

    # Retrieves the detailed security related information of the ISBM service provider.
    # 
    # Returns a Hash using symbolic keys, with all known properties present and matching 
    # the ISBM specification names.
    #
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [Hash] a Hash containing all of the security configuration details of the ISBM
    def get_security_details(options = {})
      data, _status_code, _headers = get_security_details_with_http_info(options)
      default_security_details.merge(data.to_hash)
    rescue ApiError => e
      raise IsbmAdaptor::SecurityTokenFault, extract_fault_message(e.response_body) if e.code == 401
      raise IsbmAdaptor::UnknownFault
    end

    # Retrieves information about the supported operations and features of the ISBM service provider.
    #
    # Returns a Hash using symbolic keys, with all known properties present and matching 
    # the ISBM specification names.
    #
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @return [Hash] a Hash of indiactors for the supported operations and features of the ISBM
    def get_supported_operations(options = {})
      data, _status_code, _headers = get_supported_operations_with_http_info(options)
      default_supported_operations.merge(data.to_hash)
    rescue ApiError => e
      raise IsbmAdaptor::UnknownFault
    end

    private

    # Return default Hash for security details known for the current ISBM spec version.
    # This is mostly a placeholder for now but will be important in backwards/forwards 
    # compatibility.
    def default_security_details
      { 
        isTLSEnabled: nil,
        isSecurityTokenRequired: nil,
        isSecurityTokenEncryptionEnabled: nil,
        isCertificateRequired: nil,
        isRBACEnabled: nil,
        isKeyManagementServiceEnabled: nil,
        isEndToEndMessageEncryptionEnabled: nil
      }
    end

    # Return default Hash for supported operations known for the current ISBM spec version.
    # This is mostly a placeholder for now but will be important in backwards/forwards 
    # compatibility.
    def default_supported_operations
      { 
        isXMLFilteringEnabled: false,   # assume content filtering not supported
        isJSONFilteringEnabled: false,
        supportedContentFilteringLanguages: {contentFilteringLanguages: []},
        supportedAuthentications: {
          soapSupportedTokenSchemas: [ {namespaceName: "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd", schemaLocation: "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"} ],
          restSupportedAuthenticationSchemes: [ {schemeName: "Basic", schemeInfoUrl: "https://tools.ietf.org/html/rfc7617"} ]
        },
        securityLevelConformance: 1,   # min level for safety
        isDeadLetteringEnabled: false, # do not assume responses will be received after expiration
        isChannelCreationEnabled: false,    # avoid trying to create channels if we are not sure
        isOpenChannelSecuringEnabled: true, # assume channels could be modified unexpectedly (low security conformance)
        isWhitelistRequired: false,   # assume not, will find out pretty quickly if connections fail
        defaultExpiryDuration: nil,   # can be nil/nullable, or a string in xs:duration/ISO 8601 format
        additionalInformationURL: '', # no idea about a url
      }
    end
  end
end