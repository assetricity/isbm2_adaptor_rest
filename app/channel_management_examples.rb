#!/usr/bin/env ruby

require 'isbm2_adaptor_rest'

UsernameToken = ISBMRestAdaptor::UsernameToken

# Setup authorization
ISBMRestAdaptor.configure do |config|
  config.scheme = 'http'          # default 'http'
  config.host = 'localhost:3000'  # default 'localhost'
  config.base_path = '/'          # default '/'
  # Configure HTTP basic authorization: username_password
  config.username = 'client001'
  config.password = 'password001'
end

## == ChannelManagement Service
puts 'Running examples of ChannelManagement API'

channel_management = ISBMRestAdaptor::ChannelManagementApi.new

open_channel_id = '/client/test/open/channel' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
open_channel = ISBMRestAdaptor::Channel.new(uri: open_channel_id, 
                           channel_type: 'Publication', 
                           description: 'an example channel with no security tokens.')

puts "\n*** Creating channel: #{open_channel_id}"
puts "    #{open_channel}"
begin
  # Create a new channel.
  response = channel_management.create_channel(channel: open_channel)
  puts "\nRESPONSE: channel info should match what was originally sent"
  puts "    #{response}"
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

puts "\n*** Retrieving channel: #{open_channel_id}"
begin
  # GET a channel: note, security tokens will never be visible to the client.
  response = channel_management.get_channel(open_channel.uri)
  puts "\nRESPONSE: channel info should match what was originally sent"
  puts "    #{response}"
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

puts "\n*** Retrieving all (accessible) channels."
begin
  # GET a all channels: note only those for which permissions are granted will be visible.
  response = channel_management.get_channels()
  puts "\nRESPONSE: an array of channels"
  response.each do |c|
    puts "    #{c}"
  end
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end


puts "\n*** Adding security tokens to a channel"
puts "    (Note: we add the token configured for this client first so we do not lock ourselves out)"
# You can use an ordinary hash
opts = {
  # Array<SecurityToken> | The SecurityTokens to add.
  security_tokens: [{"username":"client001","password":"password001"}] # Array<SecurityToken> | The SecurityTokens to add.
}

opts[:security_tokens].each do |t|
  puts "    #{t}"
end

begin
  #Adds security tokens to a channel.
  channel_management.add_security_tokens(open_channel.uri, opts)
  puts "Tokens (hash) added successfully"
rescue ISBMRestAdaptor::ApiError => e
  puts "Server has protection enabled, tokens not added" if e.code == 409
  puts "Exception when calling ChannelManagementApi->add_security_tokens: #{e} => #{e.response_body}" unless e.code == 409
end

# Or you can use the actual Model objects
opts = {
  # Array<SecurityToken> | The SecurityTokens to add.
  security_tokens: [UsernameToken.new(username:"user001", password:"password001"),
                   UsernameToken.new(username:"someOtherUser", password:"theirPassword")]
}

opts[:security_tokens].each do |t|
  puts "    #{t}"
end

server_protection_enabled = false
begin
  #Adds security tokens to a channel.
  channel_management.add_security_tokens(open_channel.uri, opts)
  puts "Token (objects) added successfully"
rescue ISBMRestAdaptor::ApiError => e
  server_protection_enabled = e.code == 409
  puts "Server has protection enabled, tokens not added" if e.code == 409
  puts "Exception when calling ChannelManagementApi->add_security_tokens: #{e} => #{e.response_body}" unless e.code == 409
end

puts "\n*** Removing security tokens from a channel"
puts "    (Note: we use the same tokens we just added)"

opts[:security_tokens].each do |t|
  puts "    #{t}"
end

begin
  # Removes security tokens from a channel.
  channel_management.remove_security_tokens(open_channel.uri, opts)
  puts "Tokens removed successfully" unless server_protection_enabled
  puts "Uexpected success removing tokens when they were not added" if server_protection_enabled
rescue ISBMRestAdaptor::ApiError => e
  puts "Server protection enabled, so no tokens to remove" if server_protection_enabled
  puts "Exception when calling ChannelManagementApi->add_security_tokens: #{e} => #{e.response_body}" unless server_protection_enabled
end

## Secure channel, i.e., one where security tokens are provided on creation
secure_channel_id = '/client/test/secure/channel'
secure_channel = ISBMRestAdaptor::Channel.new(
                        uri: secure_channel_id, 
                        channel_type: 'Publication', 
                        description: 'an example channel WITH security tokens.',
                        security_tokens: [
                    		UsernameToken.new(
   					username: channel_management.api_client.config.username,
                                        password: channel_management.api_client.config.password)
                                ])

puts "\n*** Creating channel: #{secure_channel_id}"
puts "    #{secure_channel}"
begin
  # Create a new channel with security tokens provided from creation.
  response = channel_management.create_channel(channel: secure_channel)
  puts "\nRESPONSE: channel info should match what was originally sent excluding the security tokens"
  puts "    #{response}"
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

puts "\n*** Retrieving all (accessible) channels, again."
begin
  # GET a all channels: note only those for which permissions are granted will be visible.
  response = channel_management.get_channels()
  puts "\nRESPONSE: an array of channels"
  response.each do |c|
    puts "    #{c}"
  end
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end

puts "\n*** Adding security tokens to a channel"
puts "    (Note: we created the channel with the token for this client)"
opts = {
  # Array<SecurityToken> | The SecurityTokens to add.
  security_tokens: [{"username":"someOtherUser","password":"theirPassword"}] # Array<SecurityToken> | The SecurityTokens to add.
}

opts[:security_tokens].each do |t|
  puts "    #{t}"
end

begin
  #Adds security tokens to a channel.
  channel_management.add_security_tokens(secure_channel.uri, opts)
  puts "Tokens added successfully"
rescue ISBMRestAdaptor::ApiError => e
  puts "Exception when calling ChannelManagementApi->add_security_tokens: #{e} => #{e.response_body}"
end

puts "\n*** Removing security tokens from a channel"
puts "    (Note: we use the same tokens we just added)"

opts[:security_tokens].each do |t|
  puts "    #{t}"
end

begin
  # Removes security tokens from a channel.
  channel_management.remove_security_tokens(secure_channel.uri, opts)
  puts "Tokens removed successfully"
rescue ISBMRestAdaptor::ApiError => e
  puts "Exception when calling ChannelManagementApi->add_security_tokens: #{e} => #{e.response_body}"
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

puts "\n*** Deleting channel: #{secure_channel_id}"
begin
  # Delete a channel (no response content).
  channel_management.delete_channel(secure_channel.uri)
  puts 'Channel deleted successfully'
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end


puts "\n*** Retrieving all (accessible) channels."
begin
  # GET a all channels: note only those for which permissions are granted will be visible.
  response = channel_management.get_channels()
  puts "\nRESPONSE: should be an empty array"
  puts "    Is empty? #{response.empty?}"
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e} => #{e.response_body}"
end
