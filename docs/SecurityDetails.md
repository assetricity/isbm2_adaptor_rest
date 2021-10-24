# IsbmRestAdaptor::SecurityDetails

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **is_tls_enabled** | **Boolean** |  |  |
| **is_security_token_required** | **Boolean** |  |  |
| **is_security_token_encryption_enabled** | **Boolean** |  |  |
| **is_certificate_required** | **Boolean** |  |  |
| **is_rbac_enabled** | **Boolean** |  |  |
| **is_key_management_service_enabled** | **Boolean** |  |  |
| **is_end_to_end_message_encryption_enabled** | **Boolean** |  |  |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = IsbmRestAdaptor::SecurityDetails.new(
  is_tls_enabled: null,
  is_security_token_required: null,
  is_security_token_encryption_enabled: null,
  is_certificate_required: null,
  is_rbac_enabled: null,
  is_key_management_service_enabled: null,
  is_end_to_end_message_encryption_enabled: null
)
```

