# IsbmRestAdaptor::Notification

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** |  | [optional] |
| **message_id** | **String** |  | [optional] |
| **topics** | **Array&lt;String&gt;** |  | [optional] |
| **request_message_id** | **String** |  | [optional] |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = IsbmRestAdaptor::Notification.new(
  session_id: null,
  message_id: null,
  topics: null,
  request_message_id: null
)
```

