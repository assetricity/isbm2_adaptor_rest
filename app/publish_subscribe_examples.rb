#!/usr/bin/env ruby

require 'isbm2_adaptor_rest'

UsernameToken = IsbmRestAdaptor::UsernameToken

# Setup authorization
IsbmRestAdaptor.configure do |config|
  config.scheme = 'http'          # default 'http'
  config.host = 'localhost:3000'  # default 'localhost'
  config.base_path = '/'          # default '/'
  # Configure HTTP basic authorization: username_password
  config.username = 'client001'
  config.password = 'password001'
end

## == ChannelManagement Service to create a couple of channels

channel_management = IsbmRestAdaptor::ChannelManagementApi.new

open_channel_id = '/client/pub/sub/channel'
open_channel = IsbmRestAdaptor::Channel.new(uri: open_channel_id, 
                           channel_type: 'Publication', 
                           description: 'an example channel with no security tokens.')

secure_channel_id = '/client/pub/sub/secure/channel'
secure_channel = IsbmRestAdaptor::Channel.new(
                        uri: secure_channel_id, 
                        channel_type: 'Publication', 
                        description: 'an example channel WITH security tokens.',
                        security_tokens: [
                    		UsernameToken.new(
   					username: channel_management.api_client.config.username,
                                        password: channel_management.api_client.config.password)
                                ])

puts "\n*** Creating channels for pub/sub: #{open_channel_id} and #{secure_channel_id}"


begin
  channel_management.create_channel(channel: open_channel)
  channel_management.create_channel(channel: secure_channel)
  puts "    Channels Created! Listing below:"
  response = channel_management.get_channels()
  response.each do |c|
    puts "    - #{c}"
  end
rescue IsbmRestAdaptor::ApiError => e
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

## Publish/Subscribe examples

publication_service = IsbmRestAdaptor::ProviderPublicationServiceApi.new
subscription_service = IsbmRestAdaptor::ConsumerPublicationServiceApi.new

puts "\n*** Opening subscription session"
subscriber_session = IsbmRestAdaptor::Session.new(topics: ['t1', 't2'])
begin
  # Open session: respond with session id
  response = subscription_service.open_subscription_session(open_channel.uri, session: subscriber_session)
  puts "Session opened successfully: #{response}"
  subscriber_session.session_id = response.session_id
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
end


puts "\n*** Opening SECOND subscription session"
subscriber_session2 = IsbmRestAdaptor::Session.new(topics: ['t1'])
begin
  # Open session: respond with session id
  response = subscription_service.open_subscription_session(open_channel.uri, session: subscriber_session2)
  puts "Session opened successfully: #{response}"
  subscriber_session2.session_id = response.session_id
rescue IsbmRestAdaptor::ApiError => e
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
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->open_publication_session: #{e} => #{e.response_body}"
end


## Open sessions---SECURE

puts "\n*** Opening SECURE subscription session"
secure_sub_session = IsbmRestAdaptor::Session.new(topics: ['t1', 't2'])
begin
  # Open session: respond with session id
  response = subscription_service.open_subscription_session(secure_channel.uri, session: secure_sub_session)
  puts "Session opened successfully: #{response}"
  secure_sub_session.session_id = response.session_id
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
end


secure_pub_session = nil
puts "\n*** Opening SECURE publication session"
begin
  # Open session: respond with session id
  response = publication_service.open_publication_session(secure_channel.uri)
  puts "Session opened successfully: #{response}"
  secure_pub_session = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->open_publication_session: #{e} => #{e.response_body}"
end

## Do publish and read

puts "\n*** Publishing to the channel"
publish_message = IsbmRestAdaptor::Message.new(
  topics: ['t1', 't3'], 
  expiry: 'P1D',
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'this is some content'})
)
begin
  # Publish message: respond with message id
  response = publication_service.post_publication(publication_session.session_id, message: publish_message)
  puts "Message published successfully: #{response}"
  publish_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
end


puts "\n*** Reading published message"
read_message = nil
begin
  # Read publication: respond with message hash
  response = subscription_service.read_publication(subscriber_session.session_id)
  puts "Message read successfully: #{response}"
  read_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->read_publication: #{e} => #{e.response_body}"
end

puts "\n*** Expire the publication."
begin
  # Expire message: respond with no content
  publication_service.expire_publication(publication_session.session_id, publish_message.message_id)
  puts "Message expired successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
end

puts "\n*** Removing published message"
unless read_message.nil?
  begin
    # Remove publication: respond with no content
    subscription_service.remove_publication(subscriber_session.session_id)
    puts "Message removed successfully"
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling PublicationConsumerApi->remove_publication: #{e} => #{e.response_body}"
  end  
end

## Do publish and read---SECURE

# First test the authentication
user = channel_management.api_client.config.username
pass = channel_management.api_client.config.password
channel_management.api_client.config.username = nil
channel_management.api_client.config.password = nil

puts "\n*** Publishing to the SECURE channel: SHOULD FAIL AS UNAUTHORIZED"
publish_message = IsbmRestAdaptor::Message.new(
  topics: ['t1', 't3'],
  expiry: 'P1D',
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'this is some "secure" content'})
)
begin
  # Publish message: respond with message id
  response = publication_service.post_publication(secure_pub_session.session_id, message: publish_message)
  puts "!!! O' oh. Message published successfully: #{response}"
  publish_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "This should be an Unauthorized response ProviderPublicationService->post_publication: #{e}"
ensure
  # reinstate the access
  channel_management.api_client.config.username = user
  channel_management.api_client.config.password = pass
end

puts "\n*** Publishing to the SECURE channel"
publish_message = IsbmRestAdaptor::Message.new(
  topics: ['t1', 't3'],
  expiry: 'P1D',
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'this is some "secure" content'})
)
begin
  # Publish message: respond with message id
  response = publication_service.post_publication(secure_pub_session.session_id, message: publish_message)
  puts "Message published successfully: #{response}"
  publish_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
end


puts "\n*** Reading SECURE published message"
read_message = nil
begin
  # Read publication: respond with message hash
  response = subscription_service.read_publication(secure_sub_session.session_id)
  puts "Message read successfully: #{response}"
  read_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->read_publication: #{e} => #{e.response_body}"
end

puts "\n*** Expire the publication."
begin
  # Expire SECURE message: respond with no content
  publication_service.expire_publication(secure_pub_session.session_id, publish_message.message_id)
  puts "Message expired successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->post_publication: #{e} => #{e.response_body}"
end

puts "\n*** Removing SECURE published message"
unless read_message.nil?
  begin
    # Remove publication: respond with no content
    subscription_service.remove_publication(secure_sub_session.session_id)
    puts "Message removed successfully"
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling PublicationConsumerApi->remove_publication: #{e} => #{e.response_body}"
  end  
end


## Closing the publish/subscribe channels on the open channel

puts "\n*** Closing subscription session on open channel"
begin
  # Close session: respond with nil
  subscription_service.close_session(subscriber_session.session_id)
  puts "Session closed successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
end

puts "\n*** Closing subscription session on open channel"
begin
  # Close session: respond with nil
  subscription_service.close_session(subscriber_session2.session_id)
  puts "Session closed successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
end

puts "\n*** Closing publication session on open channel"
begin
  # Close session: respond with nil
  publication_service.close_session(publication_session.session_id)
  puts "Session closed successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling PublicationProviderApi->close_session: #{e} => #{e.response_body}"
end

## Delete the channels, just being tidy

puts "\n*** Deleting channel: #{open_channel_id}"
begin
  # Delete a channel (no response content).
  channel_management.delete_channel(open_channel.uri)
  puts 'Channel deleted successfully'
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

# Sessions on the Secure channel should be auto-invalidated when the session is closed.
puts "\n*** Deleting channel: #{secure_channel_id}"
begin
  # Delete a channel (no response content).
  channel_management.delete_channel(secure_channel.uri)
  puts 'Channel deleted successfully'
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end
