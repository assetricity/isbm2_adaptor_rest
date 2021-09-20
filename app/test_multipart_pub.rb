#!/usr/bin/env ruby

require 'isbm2_adaptor_rest'

UsernameToken = ISBMRestAdaptor::UsernameToken

# Setup authorization
ISBMRestAdaptor.configure do |config|
  config.scheme = 'http'          # default 'http'
  config.host = 'localhost:3000'  # default 'localhost'
  config.base_path = '/'          # default '/'
  # Configure HTTP basic authorization: username_password
  # config.username = 'client001'
  # config.password = 'password001'
end

## == ChannelManagement Service to create a couple of channels

channel_management = ISBMRestAdaptor::ChannelManagementApi.new

open_channel_id = '/client/pub/sub/channel'
open_channel = ISBMRestAdaptor::Channel.new(uri: open_channel_id, 
                           channelType: 'Publication', 
                           description: 'an example channel with no security tokens.')

puts "\n*** Creating channels for pub/sub: #{open_channel_id}"


begin
  channel_management.create_channel(channel: open_channel)
  puts "    Channels Created! Listing below:"
  response = channel_management.get_channels()
  response.each do |c|
    puts "    - #{c}"
  end
rescue ISBMRestAdaptor::ApiError => e
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

## Publish/Subscribe examples

publication_service = ISBMRestAdaptor::ProviderPublicationServiceApi.new
subscription_service = ISBMRestAdaptor::ConsumerPublicationServiceApi.new

puts "\n*** Opening subscription session"
subscriber_session = ISBMRestAdaptor::Session.new(topics: ['t1', 't2'])
begin
  # Open session: respond with session id
  response = subscription_service.open_subscription_session(open_channel.uri, session: subscriber_session)
  puts "Session opened successfully: #{response}"
  subscriber_session.session_id = response.session_id
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
end


publication_session = nil
puts "\n*** Opening publication session"
begin
  # Open session: respond with session id
  response = publication_service.open_publication_session(open_channel.uri)
  puts "Session opened successfully: #{response}"
  publication_session = response
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->open_publication_session: #{e} => #{e.response_body}"
end


## Do publish and read

puts "\n*** Publishing to the channel"
publish_message = ISBMRestAdaptor::MessageMultiPart.new(
  topics: ['t1', 't3'], 
  expiry: 'P1D', 
  message_content: {test: 'this is some content'}
)
begin
  # Publish message: respond with message id
  response = publication_service.post_publication(publication_session.session_id, publish_message.to_hash)
  puts "Message published successfully: #{response}"
  publish_message = response
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
end


# puts "\n*** Reading published message"
# read_message = nil
# begin
#   # Read publication: respond with message hash
#   response = subscription_service.read_publication(subscriber_session.session_id)
#   puts "Message read successfully: #{response}"
#   read_message = response
# rescue ISBMRestAdaptor::ApiError => e
#   ## TODO: make the errors parse the response
#   puts "Exception when calling PublicationConsumerApi->read_publication: #{e} => #{e.response_body}"
# end

# puts "\n*** Expire the publication."
# begin
#   # Expire message: respond with no content
#   publication_service.expire_publication(publication_session.session_id, publish_message.message_id)
#   puts "Message expired successfully"
# rescue ISBMRestAdaptor::ApiError => e
#   ## TODO: make the errors parse the response
#   puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
# end

# puts "\n*** Removing published message"
# unless read_message.nil?
#   begin
#     # Remove publication: respond with no content
#     subscription_service.remove_publication(subscriber_session.session_id)
#     puts "Message removed successfully"
#   rescue ISBMRestAdaptor::ApiError => e
#     ## TODO: make the errors parse the response
#     puts "Exception when calling PublicationConsumerApi->remove_publication: #{e} => #{e.response_body}"
#   end  
# end


## Closing the publish/subscribe channels on the open channel

puts "\n*** Closing subscription session on open channel"
begin
  # Close session: respond with nil
  subscription_service.close_session(subscriber_session.session_id)
  puts "Session closed successfully"
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
end


puts "\n*** Closing publication session on open channel"
begin
  # Close session: respond with nil
  publication_service.close_session(publication_session.session_id)
  puts "Session closed successfully"
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->close_session: #{e} => #{e.response_body}"
end

## Delete the channels, just being tidy

puts "\n*** Deleting channel: #{open_channel_id}"
begin
  # Delete a channel (no response content).
  channel_management.delete_channel(open_channel.uri)
  puts 'Channel deleted successfully'
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end
