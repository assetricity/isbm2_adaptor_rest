# ISBMRestAdaptor::Channel

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **uri** | **String** |  |  |
| **channel_type** | [**ChannelType**](ChannelType.md) |  |  |
| **description** | **String** |  | [optional] |
| **security_tokens** | **Array&lt;SecurityToken, UsernameToken, Hash&gt;** | This can be provided when creating a channel but must never be returned. | [optional] |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = ISBMRestAdaptor::Channel.new(
  uri: null,
  channel_type: null,
  description: null,
  security_tokens: null
)
```

