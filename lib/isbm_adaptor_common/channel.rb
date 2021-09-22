module IsbmAdaptor
  class Channel
    # Channel types permitted by the ISBM specification
    TYPES = ['Publication', 'Request']

    # @return [String] the channel URI
    attr_accessor :uri

    # @return [String] the channel type, either 'Publication' or 'Request'
    attr_accessor :type

    # @return [String] the channel description
    attr_accessor :description

    # Creates a new Channel.
    #
    # @param uri [String] the channel URI
    # @param type [String] the channel type, either 'Publication' or 'Request'
    # @param description [String] the channel description
    def initialize(uri, type, description)
      @uri = uri.to_s
      @type = type
      @description = description.to_s unless description.nil?
    end

    # Creates a new Channel based on a hash.
    #
    # @option hash [String] :channel_uri the channel URI
    # @option hash [String] :channel_type the channel type, either 'Publication' or 'Request'
    # @option hash [String] :channel_description the channel description
    def self.from_hash(hash)
      uri = hash[:channel_uri]
      type = hash[:channel_type]
      description = hash[:channel_description]
      new(uri, type, description)
    end
  end
end
