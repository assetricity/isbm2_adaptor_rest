module IsbmAdaptor
  class Duration
    # @return [Numeric] the years component of the duration
    attr_accessor :years

    # @return [Numeric] the months component of the duration
    attr_accessor :months

    # @return [Numeric] the days component of the duration
    attr_accessor :days

    # @return [Numeric] the hours component of the duration
    attr_accessor :hours

    # @return [Numeric] the minutes component of the duration
    attr_accessor :minutes

    # @return [Numeric] the seconds component of the duration
    attr_accessor :seconds

    # Creates a new Duration based on specified time components.
    #
    # @option duration [Numeric] :years duration in years
    # @option duration [Numeric] :months duration in months
    # @option duration [Numeric] :days duration in days
    # @option duration [Numeric] :hours duration in hours
    # @option duration [Numeric] :minutes duration in minutes
    # @option duration [Numeric] :seconds duration in seconds
    def initialize(duration)
      duration.keys.each do |key|
        raise ArgumentError.new "Invalid key: #{key}" unless VALID_SYMBOLS.include?(key)
      end

      duration.each do |key, value|
        raise ArgumentError.new "Value for #{key} cannot be less than 0" if value < 0
      end

      @years = duration[:years]
      @months = duration[:months]
      @days = duration[:days]
      @hours = duration[:hours]
      @minutes = duration[:minutes]
      @seconds = duration[:seconds]
    end

    # @return [String] ISO 8601 formatted duration
    def to_s
      date = []
      date << "#{@years}Y" unless @years.nil?
      date << "#{@months}M" unless @months.nil?
      date << "#{@days}D" unless @days.nil?

      time = []
      time << "#{@hours}H" unless @hours.nil?
      time << "#{@minutes}M" unless @minutes.nil?
      time << "#{@seconds}S" unless @seconds.nil?

      result = nil

      if !date.empty? || !time.empty?
        result = 'P'
        result += date.join unless date.empty?
        result += 'T' + time.join unless time.empty?
      end

      result
    end

    # Creates a hash of the time components. Any keys with nil values are
    # excluded from the result.
    #
    # @return [Hash] all specified time components
    def to_hash
      hash = {}
      hash[:years] = @years if @years
      hash[:months] = @months if @months
      hash[:days] = @days if @days
      hash[:hours] = @hours if @hours
      hash[:minutes] = @minutes if @minutes
      hash[:seconds] = @seconds if @seconds
      hash
    end

    private
    # Valid time components in a duration 
    VALID_SYMBOLS = [:years, :months, :days, :hours, :minutes, :seconds]
  end
end
