# IsbmRestAdaptor::SupportedOperations

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **is_xml_filtering_enabled** | **Boolean** |  |  |
| **is_json_filtering_enabled** | **Boolean** |  |  |
| **supported_content_filtering_languages** | [**SupportedOperationsSupportedContentFilteringLanguages**](SupportedOperationsSupportedContentFilteringLanguages.md) |  |  |
| **supported_authentications** | [**SupportedOperationsSupportedAuthentications**](SupportedOperationsSupportedAuthentications.md) |  |  |
| **security_level_conformance** | **Float** |  |  |
| **is_dead_lettering_enabled** | **Boolean** |  |  |
| **is_channel_creation_enabled** | **Boolean** |  |  |
| **is_open_channel_securing_enabled** | **Boolean** |  |  |
| **is_whitelist_required** | **Boolean** |  |  |
| **default_expiry_duration** | **String** | Duration as defined by XML Schema xs:duration, http://w3c.org/TR/xmlschema-2/#duration, or  null |  |
| **additional_information_url** | **String** |  |  |

## Example

```ruby
require 'isbm2_adaptor_rest'

instance = IsbmRestAdaptor::SupportedOperations.new(
  is_xml_filtering_enabled: null,
  is_json_filtering_enabled: null,
  supported_content_filtering_languages: null,
  supported_authentications: null,
  security_level_conformance: null,
  is_dead_lettering_enabled: null,
  is_channel_creation_enabled: null,
  is_open_channel_securing_enabled: null,
  is_whitelist_required: null,
  default_expiry_duration: null,
  additional_information_url: null
)
```

