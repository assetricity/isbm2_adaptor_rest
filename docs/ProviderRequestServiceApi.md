# IsbmRestAdaptor::ProviderRequestServiceApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**close_session**](ProviderRequestServiceApi.md#close_session) | **DELETE** /sessions/{session-id} | Closes a session. |
| [**open_provider_request_session**](ProviderRequestServiceApi.md#open_provider_request_session) | **POST** /channels/{channel-uri}/provider-request-sessions | Opens a provider request session for a channel for reading requests and posting responses. |
| [**post_response**](ProviderRequestServiceApi.md#post_response) | **POST** /sessions/{session-id}/requests/{request-id}/responses | Posts a response message on a channel. |
| [**read_request**](ProviderRequestServiceApi.md#read_request) | **GET** /sessions/{session-id}/request | Returns the first non-expired request message or a previously read expired message that satisfies the session message filters. |
| [**remove_request**](ProviderRequestServiceApi.md#remove_request) | **DELETE** /sessions/{session-id}/request | Deletes the first request message, if any, in the session message queue. |


## close_session

> close_session(session_id)

Closes a session.

Closes a session of any type. All unexpired messages that have been posted during the session will be expired. ***Note*** This interface is shared by Close Publication Session, Close Subscription Session, Close Provider Request Session, and Close Consumer Request Session.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
IsbmRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = IsbmRestAdaptor::ProviderRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to be accessed (retrieved, deleted, modified, etc.)

begin
  # Closes a session.
  api_instance.close_session(session_id)
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->close_session: #{e}"
end
```

#### Using the close_session_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> close_session_with_http_info(session_id)

```ruby
begin
  # Closes a session.
  data, status_code, headers = api_instance.close_session_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->close_session_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to be accessed (retrieved, deleted, modified, etc.) |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## open_provider_request_session

> <Session> open_provider_request_session(channel_uri, opts)

Opens a provider request session for a channel for reading requests and posting responses.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
IsbmRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = IsbmRestAdaptor::ProviderRequestServiceApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
opts = {
  session: IsbmRestAdaptor::Session.new({session_id: 'session_id_example'}) # Session | The configuration of the session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided.
}

begin
  # Opens a provider request session for a channel for reading requests and posting responses.
  result = api_instance.open_provider_request_session(channel_uri, opts)
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->open_provider_request_session: #{e}"
end
```

#### Using the open_provider_request_session_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Session>, Integer, Hash)> open_provider_request_session_with_http_info(channel_uri, opts)

```ruby
begin
  # Opens a provider request session for a channel for reading requests and posting responses.
  data, status_code, headers = api_instance.open_provider_request_session_with_http_info(channel_uri, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Session>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->open_provider_request_session_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |
| **session** | [**Session**](Session.md) | The configuration of the session, i.e., topic filtering, content-filtering, and notification listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided. | [optional] |

### Return type

[**Session**](Session.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## post_response

> <Message> post_response(session_id, request_id, opts)

Posts a response message on a channel.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
IsbmRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = IsbmRestAdaptor::ProviderRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the message will/is posted.
request_id = 'request_id_example' # String | The identifier of the origianal request for the response.
opts = {
  message: IsbmRestAdaptor::Message.new # Message | The Message to be published. Only MessageContent is allowed in the request body.
}

begin
  # Posts a response message on a channel.
  result = api_instance.post_response(session_id, request_id, opts)
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->post_response: #{e}"
end
```

#### Using the post_response_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Message>, Integer, Hash)> post_response_with_http_info(session_id, request_id, opts)

```ruby
begin
  # Posts a response message on a channel.
  data, status_code, headers = api_instance.post_response_with_http_info(session_id, request_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Message>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->post_response_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the message will/is posted. |  |
| **request_id** | **String** | The identifier of the original request for the response. |  |
| **message** | [**Message**](Message.md) | The Message to be published. Only MessageContent is allowed in the request body. | [optional] |

### Return type

[**Message**](Message.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## read_request

> <Message> read_request(session_id)

Returns the first non-expired request message or a previously read expired message that satisfies the session message filters.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
IsbmRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = IsbmRestAdaptor::ProviderRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the request message was posted.

begin
  # Returns the first non-expired request message or a previously read expired message that satisfies the session message filters.
  result = api_instance.read_request(session_id)
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->read_request: #{e}"
end
```

#### Using the read_request_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Message>, Integer, Hash)> read_request_with_http_info(session_id)

```ruby
begin
  # Returns the first non-expired request message or a previously read expired message that satisfies the session message filters.
  data, status_code, headers = api_instance.read_request_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Message>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->read_request_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the request message was posted. |  |

### Return type

[**Message**](Message.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## remove_request

> remove_request(session_id)

Deletes the first request message, if any, in the session message queue.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'
# setup authorization
IsbmRestAdaptor.configure do |config|
  # Configure HTTP basic authorization: username_password
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = IsbmRestAdaptor::ProviderRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the request message was posted.

begin
  # Deletes the first request message, if any, in the session message queue.
  api_instance.remove_request(session_id)
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->remove_request: #{e}"
end
```

#### Using the remove_request_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> remove_request_with_http_info(session_id)

```ruby
begin
  # Deletes the first request message, if any, in the session message queue.
  data, status_code, headers = api_instance.remove_request_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderRequestServiceApi->remove_request_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the request message was posted. |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml

