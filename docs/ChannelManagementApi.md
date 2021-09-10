# ISBMRestAdaptor::ChannelManagementApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_security_tokens**](ChannelManagementApi.md#add_security_tokens) | **POST** /channels/{channel-uri}/security-tokens | Adds security tokens to a channel. |
| [**create_channel**](ChannelManagementApi.md#create_channel) | **POST** /channels | Create a new channel with the specified URI path fragment. |
| [**delete_channel**](ChannelManagementApi.md#delete_channel) | **DELETE** /channels/{channel-uri} | Delete the Channel specified by &#39;channel-uri&#39; |
| [**get_channel**](ChannelManagementApi.md#get_channel) | **GET** /channels/{channel-uri} | Retrieve the Channel identified by &#39;channel-uri&#39; |
| [**get_channels**](ChannelManagementApi.md#get_channels) | **GET** /channels | Retrieve all the channels, subject to security permissions. |
| [**remove_security_tokens**](ChannelManagementApi.md#remove_security_tokens) | **DELETE** /channels/{channel-uri}/security-tokens | Removes security tokens from a channel. |


## add_security_tokens

> add_security_tokens(channel_uri, opts)

Adds security tokens to a channel.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
ISBMRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ISBMRestAdaptor::ChannelManagementApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
opts = {
  security_tokens: [{"username":"user001","password":"password001"},{"username":"someOtherUser","password":"theirPassword"}] # Array<SecurityToken|UsernameToken|Hash> | The SecurityTokens to add.
}

begin
  # Adds security tokens to a channel.
  api_instance.add_security_tokens(channel_uri, opts)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->add_security_tokens: #{e}"
end
```

#### Using the add_security_tokens_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> add_security_tokens_with_http_info(channel_uri, opts)

```ruby
begin
  # Adds security tokens to a channel.
  data, status_code, headers = api_instance.add_security_tokens_with_http_info(channel_uri, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->add_security_tokens_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |
| **security_tokens** | **Array&lt;SecurityToken, UsernameToken, Hash&gt;** | The SecurityTokens to add. | [optional] |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## create_channel

> <Channel> create_channel(opts)

Create a new channel with the specified URI path fragment.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'

api_instance = ISBMRestAdaptor::ChannelManagementApi.new
opts = {
  channel: ISBMRestAdaptor::Channel.new({uri: 'uri_example', channel_type: ISBMRestAdaptor::ChannelType::PUBLICATION}) # Channel | The Channel to create
}

begin
  # Create a new channel with the specified URI path fragment.
  result = api_instance.create_channel(opts)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->create_channel: #{e}"
end
```

#### Using the create_channel_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Channel>, Integer, Hash)> create_channel_with_http_info(opts)

```ruby
begin
  # Create a new channel with the specified URI path fragment.
  data, status_code, headers = api_instance.create_channel_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Channel>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->create_channel_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel** | [**Channel**](Channel.md) | The Channel to create | [optional] |

### Return type

[**Channel**](Channel.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## delete_channel

> delete_channel(channel_uri)

Delete the Channel specified by 'channel-uri'

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
ISBMRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ISBMRestAdaptor::ChannelManagementApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)

begin
  # Delete the Channel specified by 'channel-uri'
  api_instance.delete_channel(channel_uri)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->delete_channel: #{e}"
end
```

#### Using the delete_channel_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> delete_channel_with_http_info(channel_uri)

```ruby
begin
  # Delete the Channel specified by 'channel-uri'
  data, status_code, headers = api_instance.delete_channel_with_http_info(channel_uri)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->delete_channel_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## get_channel

> <Channel> get_channel(channel_uri)

Retrieve the Channel identified by 'channel-uri'

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
ISBMRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ISBMRestAdaptor::ChannelManagementApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)

begin
  # Retrieve the Channel identified by 'channel-uri'
  result = api_instance.get_channel(channel_uri)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->get_channel: #{e}"
end
```

#### Using the get_channel_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Channel>, Integer, Hash)> get_channel_with_http_info(channel_uri)

```ruby
begin
  # Retrieve the Channel identified by 'channel-uri'
  data, status_code, headers = api_instance.get_channel_with_http_info(channel_uri)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Channel>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->get_channel_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |

### Return type

[**Channel**](Channel.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## get_channels

> <Array<Channel>> get_channels

Retrieve all the channels, subject to security permissions.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
ISBMRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ISBMRestAdaptor::ChannelManagementApi.new

begin
  # Retrieve all the channels, subject to security permissions.
  result = api_instance.get_channels
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->get_channels: #{e}"
end
```

#### Using the get_channels_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<Channel>>, Integer, Hash)> get_channels_with_http_info

```ruby
begin
  # Retrieve all the channels, subject to security permissions.
  data, status_code, headers = api_instance.get_channels_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<Channel>>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->get_channels_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**Array&lt;Channel&gt;**](Channel.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## remove_security_tokens

> remove_security_tokens(channel_uri, opts)

Removes security tokens from a channel.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
ISBMRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ISBMRestAdaptor::ChannelManagementApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
opts = {
  security_tokens: [{"username":"user001","password":"password001"},{"username":"someOtherUser","password":"theirPassword"}] # Array<SecurityToken|UsernameToken|Hash> | The security tokens to remove: each token must be specified in full to be removed, i.e., specifying only the username of a UsernamePassword token is insufficient.
}

begin
  # Removes security tokens from a channel.
  api_instance.remove_security_tokens(channel_uri, opts)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->remove_security_tokens: #{e}"
end
```

#### Using the remove_security_tokens_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> remove_security_tokens_with_http_info(channel_uri, opts)

```ruby
begin
  # Removes security tokens from a channel.
  data, status_code, headers = api_instance.remove_security_tokens_with_http_info(channel_uri, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ChannelManagementApi->remove_security_tokens_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |
| **security_tokens** | **Array&lt;SecurityToken, UsernameToken, Hash&gt;** | The security tokens to remove: each token must be specified in full to be removed, i.e., specifying only the username of a UsernamePassword token is insufficient. | [optional] |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml

