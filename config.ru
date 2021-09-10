# config.ru For easily running the notification service via Rack.

require 'rack'
require 'rack/contrib'
require 'isbm2_adaptor_rest'

# At most 20 hits per 2 seconds, will block for 60 seconds
# TODO: pull these values from a config file/Configuration object
# TODO: dynamic white list based on open sessions or pre-known ISBM address (:whitelist option)
use Rack::Deflect, :log => $stdout, :request_threshold => 20, :interval => 2, :block_duration => 60

use Rack::Recursive
use Rack::Logger #, ::Logger::WARN

map '/notifications' do
  # Use simple endpoint to filter the request URL and request methods.
  # This way the notification service only has to worry about whether 
  # the parameters are there or not. This makes it more flexible if we
  # change the definition of the service.
  use Rack::SimpleEndpoint, %r{^/(?!([^/]+)/([^/]+))$} do |req, res, match|
    req.logger.info("Invalid session/message path: redirecting to Not Found")
    raise Rack::ForwardRequest.new('/')
  end
  use Rack::SimpleEndpoint, %r{^/.+$} => [:get, :head, :post, :delete, :options, :patch, :link, :unlink] do |req, res, match|
    req.logger.info("Invalid request method: redirecting to Not Found")
    raise Rack::ForwardRequest.new('/')
  end

  # Use SimpleEndpoint to extract the session and message IDs.
  use Rack::SimpleEndpoint, %r{^/([^/]+)/([^/]+)$} => :put do |req, res, match|
    # Check for unsupported media type; Useful for testing to ensure valid Content-Type.
    # XXX if seriously using this, it should use a more advanced mime-type checking gem
    if %w(application/json application/xml).include? req.media_type
      req.update_param(:'sessionId', match[1])
      req.update_param(:'messageId', match[2])
      :pass
    else
      res.status = 415
      res['Content-Type'] = 'text/plain'
      'Must be JSON or XML'
    end
  end

  # URL and request type is valid so process the body
  # TODO: handle XML message body
  use Rack::JSONBodyParser, verbs: ['PUT'] do |body|
    JSON.parse(body, symbolize_names: true, create_additions: false)
  end

  run ISBMRestAdaptor::NotificationService.new
end

run Rack::NotFound.new