# IsbmRestAdaptor::FilterExpression

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **applicable_media_types** | **Array&lt;String&gt;** |  | [optional] |
| **expression_string** | [**FilterExpressionExpressionString**](FilterExpressionExpressionString.md) |  |  |
| **namespaces** | [**Array&lt;Namespace&gt;**](Namespace.md) |  | [optional] |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = IsbmRestAdaptor::FilterExpression.new(
  applicable_media_types: null,
  expression_string: null,
  namespaces: null
)
```

