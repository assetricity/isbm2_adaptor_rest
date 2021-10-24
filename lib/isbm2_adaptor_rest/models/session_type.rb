=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0
Contact: info@mimosa.org
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 5.2.0

=end

require 'date'
require 'time'

module IsbmRestAdaptor
  class SessionType
    PUBLICATION_PROVIDER = "PublicationProvider".freeze
    PUBLICATION_CONSUMER = "PublicationConsumer".freeze
    REQUEST_PROVIDER = "RequestProvider".freeze
    REQUEST_CONSUMER = "RequestConsumer".freeze

    # Builds the enum from string
    # @param [String] The enum value in the form of the string
    # @return [String] The enum value
    def self.build_from_hash(value)
      new.build_from_hash(value)
    end

    # Builds the enum from string
    # @param [String] The enum value in the form of the string
    # @return [String] The enum value
    def build_from_hash(value)
      constantValues = SessionType.constants.select { |c| SessionType::const_get(c) == value }
      raise "Invalid ENUM value #{value} for class #SessionType" if constantValues.empty?
      value
    end
  end
end
