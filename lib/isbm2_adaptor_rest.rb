=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0
Contact: info@mimosa.org
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 5.2.0

=end

# Common files
require 'active_support/core_ext/object/blank'
require 'isbm2_adaptor_rest/api_client'
require 'isbm2_adaptor_rest/api_error'
require 'isbm2_adaptor_rest/version'
require 'isbm2_adaptor_rest/configuration'

# Models
require 'isbm2_adaptor_rest/models/authentication_scheme'
require 'isbm2_adaptor_rest/models/channel'
require 'isbm2_adaptor_rest/models/channel_fault'
require 'isbm2_adaptor_rest/models/channel_type'
require 'isbm2_adaptor_rest/models/content_filtering_language'
require 'isbm2_adaptor_rest/models/filter_expression'
require 'isbm2_adaptor_rest/models/filter_expression_expression_string'
require 'isbm2_adaptor_rest/models/message'
require 'isbm2_adaptor_rest/models/message_content'
require 'isbm2_adaptor_rest/models/message_type'
require 'isbm2_adaptor_rest/models/namespace'
require 'isbm2_adaptor_rest/models/namespace_fault'
require 'isbm2_adaptor_rest/models/notification' # (not generated by OpenAPI tooling?)
require 'isbm2_adaptor_rest/models/operation_fault'
require 'isbm2_adaptor_rest/models/parameter_fault'
require 'isbm2_adaptor_rest/models/security_details'
require 'isbm2_adaptor_rest/models/security_token_fault'
require 'isbm2_adaptor_rest/models/session'
require 'isbm2_adaptor_rest/models/session_fault'
require 'isbm2_adaptor_rest/models/session_type'
require 'isbm2_adaptor_rest/models/supported_operations'
require 'isbm2_adaptor_rest/models/supported_operations_supported_authentications'
require 'isbm2_adaptor_rest/models/supported_operations_supported_content_filtering_languages'
require 'isbm2_adaptor_rest/models/token_schema'
require 'isbm2_adaptor_rest/models/username_token'

# APIs
require 'isbm2_adaptor_rest/api/application_api' # (not generated by OpenAPI tooling)
require 'isbm2_adaptor_rest/api/channel_management_api'
require 'isbm2_adaptor_rest/api/configuration_discovery_service_api'
require 'isbm2_adaptor_rest/api/consumer_publication_service_api'
require 'isbm2_adaptor_rest/api/consumer_request_service_api'
require 'isbm2_adaptor_rest/api/metadata_api'
require 'isbm2_adaptor_rest/api/provider_publication_service_api'
require 'isbm2_adaptor_rest/api/provider_request_service_api'

# Notification Service (not generated by OpenAPI tooling)
require 'isbm2_adaptor_rest/notifications/session_register'

module IsbmRestAdaptor
  # Hides the require of rack, and rack-contrib, as they are optional dependencies
  autoload :NotificationService, 'isbm2_adaptor_rest/notifications/notification_service'
  autoload :ChannelManagement, 'isbm2_adaptor_rest/ext/channel_management'
  autoload :ProviderPublication, 'isbm2_adaptor_rest/ext/provider_publication'
  autoload :ConsumerPublication, 'isbm2_adaptor_rest/ext/consumer_publication'
  autoload :ProviderRequest, 'isbm2_adaptor_rest/ext/provider_request'
  autoload :ConsumerRequest, 'isbm2_adaptor_rest/ext/consumer_request'
  autoload :ConfigurationDiscovery, 'isbm2_adaptor_rest/ext/configuration_discovery'

  class << self
    # Customize default settings for the SDK using block.
    #   IsbmRestAdaptor.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end

# Alias of IsbmRestAdaptor for backwards compatibility
ISBMRestAdaptor = IsbmRestAdaptor
