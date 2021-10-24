# IsbmRestAdaptor::ProviderPublicationServiceApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**close_session**](ProviderPublicationServiceApi.md#close_session) | **DELETE** /sessions/{session-id} | Closes a session. |
| [**expire_publication**](ProviderPublicationServiceApi.md#expire_publication) | **DELETE** /sessions/{session-id}/publications/{message-id} | Expires a posted publication. |
| [**open_publication_session**](ProviderPublicationServiceApi.md#open_publication_session) | **POST** /channels/{channel-uri}/publication-sessions | Opens a publication session for a channel. |
| [**post_publication**](ProviderPublicationServiceApi.md#post_publication) | **POST** /sessions/{session-id}/publications | Posts a publication message on a channel. |


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

api_instance = IsbmRestAdaptor::ProviderPublicationServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to be accessed (retrieved, deleted, modified, etc.)

begin
  # Closes a session.
  api_instance.close_session(session_id)
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->close_session: #{e}"
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
  puts "Error when calling ProviderPublicationServiceApi->close_session_with_http_info: #{e}"
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


## expire_publication

> expire_publication(session_id, message_id)

Expires a posted publication.

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

api_instance = IsbmRestAdaptor::ProviderPublicationServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the publication was posted.
message_id = 'message_id_example' # String | The identifier of the posted publication.

begin
  # Expires a posted publication.
  api_instance.expire_publication(session_id, message_id)
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->expire_publication: #{e}"
end
```

#### Using the expire_publication_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> expire_publication_with_http_info(session_id, message_id)

```ruby
begin
  # Expires a posted publication.
  data, status_code, headers = api_instance.expire_publication_with_http_info(session_id, message_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->expire_publication_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the publication was posted. |  |
| **message_id** | **String** | The identifier of the posted publication. |  |

### Return type

nil (empty response body)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## open_publication_session

> <Session> open_publication_session(channel_uri)

Opens a publication session for a channel.

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

api_instance = IsbmRestAdaptor::ProviderPublicationServiceApi.new
channel_uri = 'channel_uri_example' # String | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)

begin
  # Opens a publication session for a channel.
  result = api_instance.open_publication_session(channel_uri)
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->open_publication_session: #{e}"
end
```

#### Using the open_publication_session_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Session>, Integer, Hash)> open_publication_session_with_http_info(channel_uri)

```ruby
begin
  # Opens a publication session for a channel.
  data, status_code, headers = api_instance.open_publication_session_with_http_info(channel_uri)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Session>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->open_publication_session_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **channel_uri** | **String** | The identifier of the channel to be accessed (retrieved, deleted, modified, etc.) |  |

### Return type

[**Session**](Session.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## post_publication

> <Message> post_publication(session_id, opts)

Posts a publication message on a channel.

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

api_instance = IsbmRestAdaptor::ProviderPublicationServiceApi.new
session_id = 'session_id_example' # String | The identifier of the session to which the message will be posted.
opts = {
  message: IsbmRestAdaptor::Message.new # Message | The Message to be published Only MessageContent, Topic, and Expiry are allowed in the request body.
}

begin
  # Posts a publication message on a channel.
  result = api_instance.post_publication(session_id, opts)
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->post_publication: #{e}"
end
```

#### Using the post_publication_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Message>, Integer, Hash)> post_publication_with_http_info(session_id, opts)

```ruby
begin
  # Posts a publication message on a channel.
  data, status_code, headers = api_instance.post_publication_with_http_info(session_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Message>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ProviderPublicationServiceApi->post_publication_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The identifier of the session to which the message will be posted. |  |
| **message** | [**Message**](Message.md) | The Message to be published Only MessageContent, Topic, and Expiry are allowed in the request body. | [optional] |

### Return type

[**Message**](Message.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: application/json, application/xml
- **Accept**: application/json, application/xml

