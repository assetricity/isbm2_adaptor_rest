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

    # Creates a FilterExpression structure for content-based filtering using, 
    # e.g., an XPath or JSONPath expression. For example,
    #   { 
    #     expression: '/*', language: 'XPath', language_version: '1.0', 
    #     applicable_media_types: ['application/xml'], 
    #     namespaces: [{"xs" => "http://www.w3.org/2001/XMLSchema"}]
    #   }
    #   XPath expressions may include the prefixes and namespaces used by the XPath expression. 
    #   The hash key represents the namespace prefix while the value represents the namespace name.
    #   For example,
    #   [{"xs" => "http://www.w3.org/2001/XMLSchema"}, {"isbm" => "http://www.openoandm.org/xml/ISBM/"}]
    #
    # @param options [Hash] optional args and local options (TODO, e.g., auth overrides)
    # @option options [String] :expression the filter expression
    # @option options [String] :language the identifier for the language, 
    #   e.g. 'XPath', 'JSONPath'
    # @option options [String] :language_version a version identifier for the 
    #   expression; must be '1.0' for 'XPath'
    # @option options [Array<Hash>] :namespaces the hash keys represent
    #   namespace prefixes while their values are namespace names
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

    # Validates the well formedness of the namespaces list and raises an error
    # if any namespace prefix is allocated multiple (different) namespace names.
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

    def build_message_content(content)
      content = {content: content} unless content_hash?(content)
      message_content = MessageContent.new(content)
      raise ArgumentError, message_content.list_invalid_properties.join(', ') if client_side_validation? && !message_content.valid?
      raise ArgumentError, 'Content cannot be missing' if client_side_validation? && message_content.content.blank?
      return message_content if message_content.content.blank? # shortcut return if client-side validation disabled and nothing to convert

      raise ArgumentError, "Content must be a String, Hash, or an Object responding to :to_xml or :to_json" unless valid_object_type?(message_content.content)

      message_content.media_type = guess_media_type(message_content.content) unless message_content.media_type || message_content.content_encoding
      if client_side_validation? && !message_content.content_encoding
        validate_xml(message_content.content) if media_type_xml?(message_content.media_type)
        validate_json(message_content.content) if media_type_json?(message_content.media_type)
      end
      normalise_content_representation(message_content)
      message_content
    end

    def extract_message_content(message_content)
      if message_content.content.is_a?(String) && !message_content.content_encoding
        return YAML.safe_load(message_content.content) if media_type_json?(message_content.media_type)
        return Nokogiri::XML(message_content.content) if media_type_xml?(message_content.media_type)
      end
      message_content.content
    end

    def content_hash?(content)
      return false unless content.is_a?(Hash)
      return false unless (content.keys - [:media_type, :content, :content_encoding]).empty?
      true
    end

    def valid_object_type?(content)
      return true if content.is_a?(String)
      return true if content.is_a?(Hash)
      return true if content.respond_to?(:to_xml)
      return true if content.respond_to?(:to_json) && content.to_json != "\"#{content.to_s}\""
      false
    end

    def guess_media_type(content)
      return nil if content.blank? || !content.is_a?(String)
      return 'application/xml' if /\A\s*\</ =~ content
      return 'application/json' if /\A\s*\{/ =~ content
      'text/plain'
    end

    def normalise_content_representation(message_content)
      return if message_content.content_encoding
      return unless media_type_json?(message_content.media_type) && media_type_json?(target_content_type)
      message_content.content = YAML.safe_load(message_content.content) if message_content.content.is_a?(String)
      message_content.media_type = nil
    end

    def target_content_type
      # current OpenAPI-based adaptor supports only JSON as main Content-Type
      'application/json'
    end
  end
end
