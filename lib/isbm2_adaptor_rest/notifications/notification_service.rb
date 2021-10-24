=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0

The Notfication Service conforms to the ws-ISBM RESTful specification but has not been generated from it.
In contrast to the other APIs, the Notification Service requires an HTTP server at the client end.
As it is a simple service, it has been implemented manually as a very simple Rack app.

=end

begin

require 'rack'
require 'rack/contrib'
# require 'default_notification_service' # TODO move the below into separate files

module IsbmRestAdaptor
  class DefaultNotificationService

    def self.start_service(opts = {})
      puts "Notification service start/stop not fully implemented or tested. Currently just exits."
      return

      ## == Configure and run the notification service
      @@rack_config = File.join(File.dirname(File.absolute_path(__FILE__)), '../config.ru')
      @@server_pid_file = File.expand_path('temp_server.pid')
      @@server_thread = nil

      puts 'Starting Notification Service...'
      @@server_thread = Thread.new do 
        Rack::Server.start(config: @@rack_config, Host: 'localhost', Port: 9292, pid: @@server_pid_file)
      end

      sleep 1 # give the server a second to initialise
      if File.exist? @@server_pid_file
        puts 'Notification Service successfully started.'
      else
        raise StandardError, 'Unable to run HTTP server for Notification Service'
      end
    end

    def self.stop_service
      puts "*** Shutting down notification service and cleaning up."
      unless @@server_thread.nil?
        Thread.kill(@@server_thread)
        @@server_thread.join
        File.delete @@server_pid_file if File.exist? @@server_pid_file 
      end
    end

    # The Configuration object holding settings to be used in the API client (service in this case).
    # We want to use the same configuration for consistency, and to configure the callbacks.
    attr_accessor :config

    # Initializes the NotificationService.
    # @option config [Configuration] Configuration for initializing the object, default to Configuration.default
    def initialize(config = Configuration.default) 
      @config = config
    end

    # Rack interface: the return value must be an Array comprising 3 elements:
    #  * the HTTP response code (as a string)
    #  * a Hash of headers
    #  * the response body as an object that responds to `each` (but not a String).
    #    Each element of the response needs to be able to be serialized to a string.
    #
    # The notification service either responds 204 if successful, or 400 (ParameterFault)
    # if there is a problem processing any of the parameters.
    #
    # @param env [Hash] The environment of the request
    # @return [Array<(String, Hash, Object.respond_to? :each)>] Triplet comprising the HTTP 
    #         response code, a Hash of headers, and the response body
    def call(env)
      request = Rack::Request.new(env)
      @config.logger.debug(request.params)
      
      notification = Notification.build_from_hash(request.params)
      @config.logger.info(notification)
      return error_response(notification) unless notification.valid?

      session = @config.session_register[notification.session_id]
      # A succesful result does not care if there is no matching session
      unless session.nil?
        begin
          validate_notification_for_session!(notification, session)
        rescue StandardError => er
          return error_response(er)
        end
        execute_callbacks(notification, session)
      else
        @config.logger.debug("No session found in SessionRegister")
      end

      ['204', {}, [] ]
    end

    private

    def error_response(error_object)
      error_string = error_object.list_invalid_properties.join("\n") if error_object.kind_of? Notification
      error_string ||= error_object.message if error_object.kind_of? StandardError
      error_string ||= 'unknown parameter error'
      
      fault = ParameterFault.new(fault: error_string)

      @config.logger.warn("Notification invalid: #{fault.fault}")
      [
        '400', 
        {'Content-Type' => 'application/json'}, 
        [fault.to_hash.to_json]
      ]
    end

    def execute_callbacks(notification, session)
      callbacks = @config.notification_service_callbacks[session.session_type] + @config.notification_service_callbacks['']

      callbacks.each do |callback|
        @config.logger.info("Executing notification callback: #{session.session_type}::#{callback.first}") unless callback.empty?
        callback.last.call(notification, session) if callback.length == 2
        rescue => ex
          @config.logger.error("Unhandled exception occurred in callback '#{callback.first}': #{ex.inspect}")
      end
    end

    def validate_notification_for_session!(notification, session)
      raise StandardError, 'Invalid notification, must NOT specify "topics" for response message notification.' unless notification.topics.nil? or notification.topics.empty? or session.session_type != SessionType::REQUEST_CONSUMER
      raise StandardError, 'Invalid notification, must NOT specify "requestMessageId" for non-response message notification.' unless notification.request_message_id.nil? or session.session_type == SessionType::REQUEST_CONSUMER
    end
  end

  class NotificationService < DefaultNotificationService
  end
end

rescue LoadError => ex
  puts "Unable to load NotificationService as Rack dependencies not available"
  # require 'null_notification_service' # move the below and above into separate files
  
  module IsbmRestAdaptor
    class NullNotificationService

      def self.start_service(opts = {})
        Configuration.default.logger.warn 'Service not started, Rack dependencies not present.'
      end
  
      def self.stop_service
        # Do nothing
      end
  
      # The Configuration object holding settings to be used in the API client (service in this case).
      # We want to use the same configuration for consistency, and to configure the callbacks.
      attr_accessor :config
  
      # Initializes the NotificationService.
      # @option config [Configuration] Configuration for initializing the object, default to Configuration.default
      def initialize(config = Configuration.default) 
        @config = config
      end
  
      # Rack interface: the return value must be an Array comprising 3 elements:
      #  * the HTTP response code (as a string)
      #  * a Hash of headers
      #  * the response body as an object that responds to `each` (but not a String).
      #    Each element of the response needs to be able to be serialized to a string.
      #
      # Null service returns 500 Internal Server Error. Just in case it has been created
      # and executed manually.
      #
      # @param env [Hash] The environment of the request
      # @return [Array<(String, Hash, Object.respond_to? :each)>] Triplet comprising the HTTP 
      #         response code, a Hash of headers, and the response body
      def call(env)
        @config.logger.warn 'Service not started, Rack dependencies not present.'
  
        ['500', {}, [] ]
      end
    end

    class NotificationService < NullNotificationService
    end
  end
end
