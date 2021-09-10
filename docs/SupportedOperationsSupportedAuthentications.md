# ISBMRestAdaptor::SupportedOperationsSupportedAuthentications

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **soap_supported_token_schemas** | [**Array&lt;TokenSchema&gt;**](TokenSchema.md) |  | [optional] |
| **rest_supported_authentication_schemes** | [**Array&lt;AuthenticationScheme&gt;**](AuthenticationScheme.md) | The scheme names must match one of the schemes mentioned in HTTP Authentication Scheme Registry [https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml]. | [optional] |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = ISBMRestAdaptor::SupportedOperationsSupportedAuthentications.new(
  soap_supported_token_schemas: null,
  rest_supported_authentication_schemes: null
)
```

