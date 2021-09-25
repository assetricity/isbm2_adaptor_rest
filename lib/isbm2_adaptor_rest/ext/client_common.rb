require 'nokogiri'
require 'yaml'

module ISBMRestAdaptor
  module ClientCommon
    def client_side_validation?
      @api_client.config.client_side_validation
    end

    def media_type_json?(media_type)
      media_type =~ %r!(/json|\+json)(\s+;\s+\S+)?\z!i
    end

    def media_type_xml?(media_type)
      media_type =~ %r!(/xml|\+xml)(\s+;\s+\S+)?\z!i
    end

    # Validates the presence of the passed value.
    #
    # @param value [Object] object to validate presence
    # @param name [String] name of value to include in error message if not present
    # @return [void]
    # @raise [ArgumentError] if value is not present
    def validate_presence_of(value, name)
      if value.respond_to?(:each)
        value.each do |v|
          if v.blank?
            raise ArgumentError, "Values in #{name} must not be blank"
          end
        end
      else
        if value.blank?
          raise ArgumentError, "#{name} must not be blank"
        end
      end
    end

    # Validates the well formedness of the XML string and raises an error if
    # any errors are encountered.
    #
    # @param xml [String] the XML string to parse
    # @return [void]
    def validate_xml(xml)
      doc = Nokogiri::XML(xml)
      raise ArgumentError, "XML content is not well formed: #{xml}" unless doc.errors.empty?
    end

    # Validates the well formedness of the JSON string and raises an error if
    # any errors are encountered.
    #
    # @param xml [String] the JSON string to parse
    # @return [void]
    def validate_json(json)
      YAML.safe_load(json)
    rescue Psych::SyntaxError
      raise ArgumentError, "JSON content is not well formed: #{json}"
    end
  end
end
