=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0

This is a helper class for the Notification Service and is not generated from the OpenAPI spec.

=end

require 'concurrent-ruby'

module ISBMRestAdaptor
  # Records open sessions to allow the Notification Service to take appropriate actions.
  # Provides a simple interface to add, remove, and retrieve Sessions.
  #
  # A more serious implementation should use some form of persistence to allow sessions to
  # be maintained between runs of the client application(s).
  #
  # For an application that does not need it, NullSessionRegister can be used.
  # The default is TransientSessionRegister.
  class SessionRegister
    
    def self.default
      @@default ||= TransientSessionRegister.new
    end

    def [](session_id)
      raise NotImplementedError, 'SessionRegister is an abstract class.'
    end

    def <<(session)
      raise NotImplementedError, 'SessionRegister is an abstract class.'
    end

    def delete(session_or_id)
      raise NotImplementedError, 'SessionRegister is an abstract class.'
    end
  end

  # This implementation of SessionRegister simply stores the sessions in a Hash
  # keyed by session_id. It has no persistence and is lost once the application 
  # terminates.
  class TransientSessionRegister < SessionRegister

    def initialize()
      @register = Concurrent::Hash.new
    end

    def [](session_id)
      @register[session_id]
    end

    def <<(session)
      return nil if session.nil?
      @register[session.session_id] = session
    end

    def delete(session_or_id)
      return @register.delete(session_or_id) if session_or_id.kind_of? String
      return @register.delete(session_or_id.session_id) if session_or_id.kind_of? Session
      nil
    end
  end

  # NullSessionRegister implements the interface as no-ops.
  class NullSessionRegister < SessionRegister
    def [](session_id); end

    def <<(session); end

    def delete(session_or_id); end
  end
end
