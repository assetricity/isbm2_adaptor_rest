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

NO_SECURE = false

## == ChannelManagement Service to create a couple of channels

channel_management = IsbmRestAdaptor::ChannelManagementApi.new

open_channel_id = '/client/request/channel'
open_channel = IsbmRestAdaptor::Channel.new(uri: open_channel_id, 
                           channel_type: 'Request', 
                           description: 'an example channel with no security tokens.')

secure_channel_id = '/client/request/secure/channel'
secure_channel = IsbmRestAdaptor::Channel.new(
                        uri: secure_channel_id, 
                        channel_type: 'Request', 
                        description: 'an example channel WITH security tokens.',
                        security_tokens: [
                    		UsernameToken.new(
   					                            username: channel_management.api_client.config.username,
                                        password: channel_management.api_client.config.password)
                                ])

puts "\n*** Creating channels for request/response: #{open_channel_id} and #{secure_channel_id}"


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

## Request/Response examples

consumer_service = IsbmRestAdaptor::ConsumerRequestServiceApi.new
provider_service = IsbmRestAdaptor::ProviderRequestServiceApi.new

puts "\n*** Opening provider request session"
provider_session = IsbmRestAdaptor::Session.new(topics: ['t1', 't2'])
begin
  # Open session: respond with session id
  response = provider_service.open_provider_request_session(open_channel.uri, session: provider_session)
  puts "Session opened successfully: #{response}"
  provider_session.session_id = response.session_id
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->open_provider_request_session: #{e} => #{e.response_body}"
end


puts "\n*** Opening SECOND provider request session"
provider_session2 = IsbmRestAdaptor::Session.new(topics: ['t1'])
begin
  # Open session: respond with session id
  response = provider_service.open_provider_request_session(open_channel.uri, session: provider_session2)
  puts "Session opened successfully: #{response}"
  provider_session2.session_id = response.session_id
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->open_provider_request_session: #{e} => #{e.response_body}"
end


consumer_session = nil
puts "\n*** Opening consumer request session"
begin
  # Open session: respond with session id
  response = consumer_service.open_consumer_request_session(open_channel.uri)
  puts "Session opened successfully: #{response}"
  consumer_session = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->open_consumer_request_session: #{e} => #{e.response_body}"
end


## Open sessions---SECURE

puts "\n*** Opening SECURE provider request session"
secure_provider_session = IsbmRestAdaptor::Session.new(topics: ['t1', 't2'])
begin
  # Open session: respond with session id
  response = provider_service.open_provider_request_session(secure_channel.uri, session: secure_provider_session)
  puts "Session opened successfully: #{response}"
  secure_provider_session.session_id = response.session_id
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->open_provider_request_session: #{e} => #{e.response_body}"
end


secure_consumer_session = nil
puts "\n*** Opening SECURE consumer request session"
begin
  # Open session: respond with session id
  response = consumer_service.open_consumer_request_session(secure_channel.uri)
  puts "Session opened successfully: #{response}"
  secure_consumer_session = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->open_consumer_request_session: #{e} => #{e.response_body}"
end

## Do request, read, expire, response, and read response

puts "\n*** Posting REQUEST to the channel"
request_message = IsbmRestAdaptor::Message.new(
  topics: ['t1', 't3'],
  expiry: 'P1D',
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'Ping!'})
)
begin
  # Post request message: respond with message id
  response = consumer_service.post_request(consumer_session.session_id, message: request_message)
  puts "Message posted successfully: #{response}"
  request_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->post_request: #{e} => #{e.response_body}"
end


puts "\n*** Reading request message"
read_message = nil
begin
  # Read request message: respond with Message
  response = provider_service.read_request(provider_session.session_id)
  puts "Message read successfully: #{response}"
  read_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->read_request: #{e} => #{e.response_body}"
end

puts "\n*** Posting RESPONSE to the channel/request"
response_message = IsbmRestAdaptor::Message.new(
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'Pong!'})
)
begin
  # Post response message: respond with message id
  response = provider_service.post_response(provider_session.session_id, read_message.message_id, message: response_message)
  puts "Message posted successfully: #{response}"
  response_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->post_response: #{e} => #{e.response_body}"
end

puts "\n*** Posting another RESPONSE to the channel/request"
response_message2 = IsbmRestAdaptor::Message.new(
  message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'Pong! AGAIN'})
)
begin
  # Post response message: respond with message id
  response = provider_service.post_response(provider_session.session_id, read_message.message_id, message: response_message2)
  puts "Message posted successfully: #{response}"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->post_response: #{e} => #{e.response_body}"
end

puts "\n*** Reading RESPONSE message"
read_response_message = nil
begin
  # Read response message: respond with Message
  response = consumer_service.read_response(consumer_session.session_id, request_message.message_id)
  puts "Message read successfully: #{response}"
  read_response_message = response
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->read_request: #{e} => #{e.response_body}"
end

puts "\n*** Expire the request message."
begin
  # Expire message: respond with no content
  consumer_service.expire_request(consumer_session.session_id, request_message.message_id)
  puts "Message expired successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->expire_request: #{e} => #{e.response_body}"
end

puts "\n*** Removing request message"
unless read_message.nil?
  begin
    # Remove request message: respond with no content
    provider_service.remove_request(provider_session.session_id)
    puts "Message removed successfully"
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ProviderRequestServiceApi->remove_request: #{e} => #{e.response_body}"
  end  
end

puts "\n*** Removing response message"
unless read_response_message.nil?
  begin
    # Remove request message: respond with no content
    consumer_service.remove_response(consumer_session.session_id, request_message.message_id)
    puts "Message removed successfully"
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ProviderRequestServiceApi->remove_request: #{e} => #{e.response_body}"
  end  
end

## Do request, read, response, read---SECURE
begin
  raise StandardError, "Skipping Secure Test" if NO_SECURE

  # First test the authentication
  user = channel_management.api_client.config.username
  pass = channel_management.api_client.config.password
  channel_management.api_client.config.username = nil
  channel_management.api_client.config.password = nil

  puts "\n*** Posting to the SECURE channel: SHOULD FAIL AS UNAUTHORIZED"
  request_message = IsbmRestAdaptor::Message.new(
    topics: ['t1', 't3'], 
    expiry: 'P1D', 
    message_content: IsbmRestAdaptor::MessageContent.new(content: {test: 'If you are seeing this, something went wrong.'})
  )
  begin
    # Post request message: respond with message id
    response = consumer_service.post_request(secure_consumer_session.session_id, message: request_message)
    puts "!!! O' oh. Message posted successfully: #{response}"
    request_message = response
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "This should be an Unauthorized response ConsumerRequestServiceApi->post_request: #{e}"
  ensure
    # reinstate the access
    channel_management.api_client.config.username = user
    channel_management.api_client.config.password = pass
  end

  puts "\n*** Posting to the SECURE channel"
  request_message = IsbmRestAdaptor::Message.new(
    topics: ['t1', 't3'], 
    expiry: 'P1D', 
    message_content: IsbmRestAdaptor::MessageContent.new(content: {test: '"secure" PING!'})
  )
  begin
    # Post request message: respond with message id
    response = consumer_service.post_request(secure_consumer_session.session_id, message: request_message)
    puts "Message posted successfully: #{response}"
    request_message = response
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ConsumerRequestServiceApi->post_request: #{e} => #{e.response_body}"
  end


  puts "\n*** Reading SECURE request message"
  read_message = nil
  begin
    # Read request message: respond with message hash
    response = provider_service.read_request(secure_provider_session.session_id)
    puts "Message read successfully: #{response}"
    read_message = response
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ProviderRequestServiceApi->read_request: #{e} => #{e.response_body}"
  end

  
  puts "\n*** Posting SECURE RESPONSE to the channel/request"
  response_message = IsbmRestAdaptor::Message.new(
    message_content: IsbmRestAdaptor::MessageContent.new(content: {test: '"secure" Pong!'})
  )
  begin
    # Post response message: respond with message id
    response = provider_service.post_response(secure_provider_session.session_id, read_message.message_id, message: response_message)
    puts "Message posted successfully: #{response}"
    response_message = response
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ConsumerRequestServiceApi->post_response: #{e} => #{e.response_body}"
  end

  puts "\n*** Reading SECURE RESPONSE message"
  read_response_message = nil
  begin
    # Read response message: respond with Message
    response = consumer_service.read_response(secure_consumer_session.session_id, request_message.message_id)
    puts "Message read successfully: #{response}"
    read_response_message = response
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ProviderRequestServiceApi->read_request: #{e} => #{e.response_body}"
  end

  puts "\n*** Expire the request message."
  begin
    # Expire SECURE message: respond with no content
    consumer_service.expire_request(secure_consumer_session.session_id, request_message.message_id)
    puts "Message expired successfully"
  rescue IsbmRestAdaptor::ApiError => e
    ## TODO: make the errors parse the response
    puts "Exception when calling ConsumerRequestServiceApi->expire_request: #{e} => #{e.response_body}"
  end

  puts "\n*** Removing SECURE request message"
  unless read_message.nil?
    begin
      # Remove request message: respond with no content
      provider_service.remove_request(secure_provider_session.session_id)
      puts "Message removed successfully"
    rescue IsbmRestAdaptor::ApiError => e
      ## TODO: make the errors parse the response
      puts "Exception when calling ProviderRequestServiceApi->remove_request: #{e} => #{e.response_body}"
    end  
  end

  puts "\n*** Removing SECURE response message"
  unless read_response_message.nil?
    begin
      # Remove request message: respond with no content
      consumer_service.remove_response(secure_consumer_session.session_id, request_message.message_id)
      puts "Message removed successfully"
    rescue IsbmRestAdaptor::ApiError => e
      ## TODO: make the errors parse the response
      puts "Exception when calling ProviderRequestServiceApi->remove_request: #{e} => #{e.response_body}"
    end  
  end

rescue StandardError
  # Keep running from here
end

## Closing the sessions on the open channel

puts "\n*** Closing provider request session on open channel"
begin
  # Close session: respond with nil
  provider_service.close_session(provider_session.session_id)
  puts "Session closed successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->open_provider_request_session: #{e} => #{e.response_body}"
end

puts "\n*** Closing provider request session on open channel"
begin
  # Close session: respond with nil
  provider_service.close_session(provider_session2.session_id)
  puts "Session closed successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ProviderRequestServiceApi->open_provider_request_session: #{e} => #{e.response_body}"
end

puts "\n*** Closing consumer request session on open channel"
begin
  # Close session: respond with nil
  consumer_service.close_session(consumer_session.session_id)
  puts "Session closed successfully"
rescue IsbmRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ConsumerRequestServiceApi->close_session: #{e} => #{e.response_body}"
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
