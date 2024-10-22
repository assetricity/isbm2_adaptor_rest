#!/usr/bin/env ruby

require 'isbm2_adaptor_rest'

# Setup authorization
IsbmRestAdaptor.configure do |config|
  config.scheme = 'http'          # default 'http'
  config.host = 'localhost:3000'  # default 'localhost'
  config.base_path = '/'          # default '/'
  # Configure HTTP basic authorization: username_password
#  config.username = 'client001'
#  config.password = 'password001'
end

publication_service = IsbmRestAdaptor::ProviderPublicationServiceApi.new

publication_session = IsbmRestAdaptor::Session.new(session_id: 1)

puts "\n*** Publishing to the channel"
publish_message = IsbmRestAdaptor::Message.new(
  topics: ['t1', 't3'], 
  expiry: 'P1D',
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'this is some content'})
)

puts publish_message

puts publish_message.to_hash

begin
  # Publish message: respond with message id
  response = publication_service.post_publication(publication_session.session_id, message: publish_message)
  puts "Message published successfully: #{response}"
  publish_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
end

