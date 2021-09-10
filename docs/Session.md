# ISBMRestAdaptor::Session

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** |  |  |
| **session_type** | [**SessionType**](SessionType.md) |  | [optional] |
| **listener_url** | **String** |  | [optional] |
| **topics** | **Array&lt;String&gt;** |  | [optional] |
| **filter_expressions** | [**Array&lt;FilterExpression&gt;**](FilterExpression.md) |  | [optional] |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = ISBMRestAdaptor::Session.new(
  session_id: null,
  session_type: null,
  listener_url: null,
  topics: null,
  filter_expressions: null
)
```

