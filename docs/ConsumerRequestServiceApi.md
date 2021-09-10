# ISBMRestAdaptor::ConsumerRequestServiceApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**close_session**](ConsumerRequestServiceApi.md#close_session) | **DELETE** /sessions/{session-id} | Closes a session. |
| [**expire_request**](ConsumerRequestServiceApi.md#expire_request) | **DELETE** /sessions/{session-id}/requests/{message-id} | Expires a posted request message. |
| [**open_consumer_request_session**](ConsumerRequestServiceApi.md#open_consumer_request_session) | **POST** /channels/{channel-uri}/consumer-request-sessions | Opens a consumer request session for a channel for posting requests and reading responses. |
| [**post_request**](ConsumerRequestServiceApi.md#post_request) | **POST** /sessions/{session-id}/requests | Posts a request message on a channel. |
| [**read_response**](ConsumerRequestServiceApi.md#read_response) | **GET** /sessions/{session-id}/requests/{request-id}/response | Returns the first response message, if any, in the session message queue associated with the request. |
| [**remove_response**](ConsumerRequestServiceApi.md#remove_response) | **DELETE** /sessions/{session-id}/requests/{request-id}/response | Deletes the first response message, if any, in the session message queue associated with the request. |


## close_session

> close_session(session_id)

Closes a session.

Closes a session of any type. All unexpired messages that have been posted during the session will be expired. ***Note*** This interface is shared by Close Publication Session, Close Subscription Session, Close Provider Request Session, and Close Consumer Request Session.

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

api_instance = ISBMRestAdaptor::ConsumerRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to be accessed (retrieved, deleted, modified, etc.)

begin
  # Closes a session.
  api_instance.close_session(session_id)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->close_session: #{e}"
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
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->close_session_with_http_info: #{e}"
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


## expire_request

> expire_request(session_id, message_id)

Expires a posted request message.

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

api_instance = ISBMRestAdaptor::ConsumerRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the request message was posted.
message_id = 'message_id_example' # String | The identifier of the posted request.

begin
  # Expires a posted request message.
  api_instance.expire_request(session_id, message_id)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->expire_request: #{e}"
end
```

#### Using the expire_request_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> expire_request_with_http_info(session_id, message_id)

```ruby
begin
  # Expires a posted request message.
  data, status_code, headers = api_instance.expire_request_with_http_info(session_id, message_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->expire_request_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the request message was posted. |  |
| **message_id** | **String** | The identifier of the posted request. |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## open_consumer_request_session

> <Session> open_consumer_request_session(channel_uri, opts)

Opens a consumer request session for a channel for posting requests and reading responses.

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

api_instance = ISBMRestAdaptor::ConsumerRequestServiceApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
opts = {
  session: ISBMRestAdaptor::Session.new({session_id: 'session_id_example'}) # Session | The configuration of the consumer request session, i.e., optional notication listener address. Only the ListenerURL is to be provided (if desired).
}

begin
  # Opens a consumer request session for a channel for posting requests and reading responses.
  result = api_instance.open_consumer_request_session(channel_uri, opts)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->open_consumer_request_session: #{e}"
end
```

#### Using the open_consumer_request_session_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Session>, Integer, Hash)> open_consumer_request_session_with_http_info(channel_uri, opts)

```ruby
begin
  # Opens a consumer request session for a channel for posting requests and reading responses.
  data, status_code, headers = api_instance.open_consumer_request_session_with_http_info(channel_uri, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Session>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->open_consumer_request_session_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |
| **session** | [**Session**](Session.md) | The configuration of the consumer request session, i.e., optional notication listener address. Only the ListenerURL is to be provided (if desired). | [optional] |

### Return type

[**Session**](Session.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## post_request

> <Message> post_request(session_id, opts)

Posts a request message on a channel.

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

api_instance = ISBMRestAdaptor::ConsumerRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the message will/is posted.
opts = {
  message: ISBMRestAdaptor::Message.new # Message | The Message to be published Only MessageContent, Topic, and Expiry are allowed in the request body. Although `topics` is an array, at most 1 value is allowed.
}

begin
  # Posts a request message on a channel.
  result = api_instance.post_request(session_id, opts)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->post_request: #{e}"
end
```

#### Using the post_request_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Message>, Integer, Hash)> post_request_with_http_info(session_id, opts)

```ruby
begin
  # Posts a request message on a channel.
  data, status_code, headers = api_instance.post_request_with_http_info(session_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Message>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->post_request_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the message will/is posted. |  |
| **message** | [**Message**](Message.md) | The Message to be published Only MessageContent, Topic, and Expiry are allowed in the request body. Although &#x60;topics&#x60; is an array, at most 1 value is allowed. | [optional] |

### Return type

[**Message**](Message.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## read_response

> <Message> read_response(session_id, request_id)

Returns the first response message, if any, in the session message queue associated with the request.

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

api_instance = ISBMRestAdaptor::ConsumerRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session at which the response message was recieved.
request_id = 'request_id_example' # String | The identifier of the origianal request for the response.

begin
  # Returns the first response message, if any, in the session message queue associated with the request.
  result = api_instance.read_response(session_id, request_id)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->read_response: #{e}"
end
```

#### Using the read_response_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Message>, Integer, Hash)> read_response_with_http_info(session_id, request_id)

```ruby
begin
  # Returns the first response message, if any, in the session message queue associated with the request.
  data, status_code, headers = api_instance.read_response_with_http_info(session_id, request_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Message>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->read_response_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session at which the response message was recieved. |  |
| **request_id** | **String** | The identifier of the origianal request for the response. |  |

### Return type

[**Message**](Message.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## remove_response

> remove_response(session_id, request_id)

Deletes the first response message, if any, in the session message queue associated with the request.

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

api_instance = ISBMRestAdaptor::ConsumerRequestServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session at which the response message was recieved.
request_id = 'request_id_example' # String | The identifier of the origianal request for the response.

begin
  # Deletes the first response message, if any, in the session message queue associated with the request.
  api_instance.remove_response(session_id, request_id)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->remove_response: #{e}"
end
```

#### Using the remove_response_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> remove_response_with_http_info(session_id, request_id)

```ruby
begin
  # Deletes the first response message, if any, in the session message queue associated with the request.
  data, status_code, headers = api_instance.remove_response_with_http_info(session_id, request_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerRequestServiceApi->remove_response_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session at which the response message was recieved. |  |
| **request_id** | **String** | The identifier of the origianal request for the response. |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml

