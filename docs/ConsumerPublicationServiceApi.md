# ISBMRestAdaptor::ConsumerPublicationServiceApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**close_session**](ConsumerPublicationServiceApi.md#close_session) | **DELETE** /sessions/{session-id} | Closes a session. |
| [**open_subscription_session**](ConsumerPublicationServiceApi.md#open_subscription_session) | **POST** /channels/{channel-uri}/subscription-sessions | Opens a subscription session for a channel. |
| [**read_publication**](ConsumerPublicationServiceApi.md#read_publication) | **GET** /sessions/{session-id}/publication | Returns the first non-expired publication message or a previously read expired message that satisfies the session message filters. |
| [**remove_publication**](ConsumerPublicationServiceApi.md#remove_publication) | **DELETE** /sessions/{session-id}/publication | Removes the first, if any, publication message in the subscription queue. |


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

api_instance = ISBMRestAdaptor::ConsumerPublicationServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to be accessed (retrieved, deleted, modified, etc.)

begin
  # Closes a session.
  api_instance.close_session(session_id)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->close_session: #{e}"
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
  puts "Error when calling ConsumerPublicationServiceApi->close_session_with_http_info: #{e}"
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


## open_subscription_session

> <Session> open_subscription_session(channel_uri, opts)

Opens a subscription session for a channel.

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

api_instance = ISBMRestAdaptor::ConsumerPublicationServiceApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
opts = {
  session: ISBMRestAdaptor::Session.new({session_id: 'session_id_example'}) # Session | The configuration of the subscription session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided.
}

begin
  # Opens a subscription session for a channel.
  result = api_instance.open_subscription_session(channel_uri, opts)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->open_subscription_session: #{e}"
end
```

#### Using the open_subscription_session_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Session>, Integer, Hash)> open_subscription_session_with_http_info(channel_uri, opts)

```ruby
begin
  # Opens a subscription session for a channel.
  data, status_code, headers = api_instance.open_subscription_session_with_http_info(channel_uri, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Session>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->open_subscription_session_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |
| **session** | [**Session**](Session.md) | The configuration of the subscription session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided. | [optional] |

### Return type

[**Session**](Session.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml


## read_publication

> <Message> read_publication(session_id)

Returns the first non-expired publication message or a previously read expired message that satisfies the session message filters.

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

api_instance = ISBMRestAdaptor::ConsumerPublicationServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the publication was posted.

begin
  # Returns the first non-expired publication message or a previously read expired message that satisfies the session message filters.
  result = api_instance.read_publication(session_id)
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->read_publication: #{e}"
end
```

#### Using the read_publication_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Message>, Integer, Hash)> read_publication_with_http_info(session_id)

```ruby
begin
  # Returns the first non-expired publication message or a previously read expired message that satisfies the session message filters.
  data, status_code, headers = api_instance.read_publication_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Message>
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->read_publication_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the publication was posted. |  |

### Return type

[**Message**](Message.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## remove_publication

> remove_publication(session_id)

Removes the first, if any, publication message in the subscription queue.

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

api_instance = ISBMRestAdaptor::ConsumerPublicationServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the publication was posted.

begin
  # Removes the first, if any, publication message in the subscription queue.
  api_instance.remove_publication(session_id)
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->remove_publication: #{e}"
end
```

#### Using the remove_publication_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> remove_publication_with_http_info(session_id)

```ruby
begin
  # Removes the first, if any, publication message in the subscription queue.
  data, status_code, headers = api_instance.remove_publication_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling ConsumerPublicationServiceApi->remove_publication_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the publication was posted. |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml

