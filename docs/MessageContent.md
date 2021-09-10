# ISBMRestAdaptor::MessageContent

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **media_type** | **String** | The MIME type of the content. If not present, it is assumed to be the same as the Content-Type of the HTTP request/response body. | [optional] |
| **content_encoding** | **String** | Indicates the encoding type used for binary content. | [optional] |
| **content** | [**OneOfstringmap**](OneOfstringmap.md) |  |  |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = ISBMRestAdaptor::MessageContent.new(
  media_type: null,
  content_encoding: null,
  content: null
)
```

