# ISBMRestAdaptor::Message

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message_id** | **String** |  | [optional] |
| **message_type** | [**MessageType**](MessageType.md) |  | [optional] |
| **message_content** | [**MessageContent**](MessageContent.md) |  | [optional] |
| **topics** | **Array&lt;String&gt;** | The Topic(s) to which the message will be posted. | [optional] |
| **expiry** | **String** | The duration after which the message will be automatically expired. Negative duration is no duration. Duration as defined by XML Schema xs:duration, http://w3c.org/TR/xmlschema-2/#duration | [optional] |
| **request_message_id** | **String** | Only valid for Response messages; refers to the original Request message. | [optional] |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = ISBMRestAdaptor::Message.new(
  message_id: null,
  message_type: null,
  message_content: null,
  topics: null,
  expiry: null,
  request_message_id: null
)
```

