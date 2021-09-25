module IsbmAdaptor
  class Message
    # @return [String] the id of the message
    attr_accessor :id

    # @return [String, Hash, Nokogiri::XML::Document] the content of the message:
    #   - String for plain text or (encoded) binary content;
    #   - Hash for JSON content;
    #   - Nokogiri::XML::Document for XML content
    attr_accessor :content

    # @return [Array<String>] topics associated with the message
    attr_accessor :topics

    # @return [String] media type (mimetype) of the content
    attr_accessor :media_type

    # @return [String] the type of encoding used for binary content, e.g., 'base64'
    attr_accessor :content_encoding

    # Creates a new ISBM Message container.
    #
    # @param id [String] message id
    # @param content [String, Hash, Nokogiri::XML::Document] the content (string, binary, JSON, XML)
    # @param topics [Array<String>, String] collection of topics or single topic
    # @param media_type [String] the media type of the content, if not provided will try to guess based on :content
    # @param content_encoding [String] type of encoding if content is binary
    def initialize(id, content, topics, media_type = nil, content_encoding = nil)
      @id = id
      @content = content
      @topics = [topics].flatten
      @media_type = media_type || guess_media_type_from_content
      @content_encoding = content_encoding
    end

    private

    def guess_media_type_from_content
      return 'application/json' if @content.is_a?(Hash)
      return 'application/xml' if @content.is_a?(Nokogiri::XML::Document)
      'text/plain'
    end
  end
end
