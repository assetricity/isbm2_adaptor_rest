#!/usr/bin/env ruby

require 'isbm2_adaptor_rest'

UsernameToken = ISBMRestAdaptor::UsernameToken

# Setup authorization
ISBMRestAdaptor.configure do |config|
  config.scheme = 'http'          # default 'http'
  config.host = 'localhost:3000'  # default 'localhost'
  config.base_path = '/'          # default '/'
  # Configure HTTP basic authorization: username_password
#  config.username = 'client001'
#  config.password = 'password001'
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

  response = channel_management.create_channel(channel: open_channel)
  raise StandardError '\n!!Should not have been able to create channel twice!!'
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->create_channels: #{e}"
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
  puts "Exception when calling ChannelManagementApi->create_channels: #{e}"
end

puts "\n*** Deleting channel: #{open_channel_id}"
begin
  # Delete a channel (no response content).
  channel_management.delete_channel(open_channel.uri)
  puts 'Channel deleted successfully'
  channel_management.delete_channel(open_channel.uri)
  raise StandardError '!!Should not have been able to delete the channel twice!!'
rescue ISBMRestAdaptor::ApiError => e
  ## TODO: make the errors parse the response
  puts "Exception when calling ChannelManagementApi->delete_channel: #{e}"
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
  puts "Exception when calling ChannelManagementApi->create_channels: #{e}"
end
