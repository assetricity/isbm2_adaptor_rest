# IsbmRestAdaptor::ConfigurationDiscoveryServiceApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_security_details**](ConfigurationDiscoveryServiceApi.md#get_security_details) | **GET** /configuration/security-details | Gets the detailed security related information of the ISBM service provider. The security details are exposed only if the connecting application provides a valid SecurityToken. Each application may be assigned a SecurityToken out-of-band by the service provider. |
| [**get_supported_operations**](ConfigurationDiscoveryServiceApi.md#get_supported_operations) | **GET** /configuration/supported-operations | Gets information about the supported operations and features of the ISBM service provider. The purpose of this operation is to allow an application to be configured appropriately to communicate successfully with the service provider. |


## get_security_details

> <SecurityDetails> get_security_details

Gets the detailed security related information of the ISBM service provider. The security details are exposed only if the connecting application provides a valid SecurityToken. Each application may be assigned a SecurityToken out-of-band by the service provider.

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

api_instance = IsbmRestAdaptor::ConfigurationDiscoveryServiceApi.new

begin
  # Gets the detailed security related information of the ISBM service provider. The security details are exposed only if the connecting application provides a valid SecurityToken. Each application may be assigned a SecurityToken out-of-band by the service provider.
  result = api_instance.get_security_details
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ConfigurationDiscoveryServiceApi->get_security_details: #{e}"
end
```

#### Using the get_security_details_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SecurityDetails>, Integer, Hash)> get_security_details_with_http_info

```ruby
begin
  # Gets the detailed security related information of the ISBM service provider. The security details are exposed only if the connecting application provides a valid SecurityToken. Each application may be assigned a SecurityToken out-of-band by the service provider.
  data, status_code, headers = api_instance.get_security_details_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SecurityDetails>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ConfigurationDiscoveryServiceApi->get_security_details_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**SecurityDetails**](SecurityDetails.md)

### Authorization

[username_password](../README.md#username_password)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml


## get_supported_operations

> <SupportedOperations> get_supported_operations

Gets information about the supported operations and features of the ISBM service provider. The purpose of this operation is to allow an application to be configured appropriately to communicate successfully with the service provider.

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'

api_instance = IsbmRestAdaptor::ConfigurationDiscoveryServiceApi.new

begin
  # Gets information about the supported operations and features of the ISBM service provider. The purpose of this operation is to allow an application to be configured appropriately to communicate successfully with the service provider.
  result = api_instance.get_supported_operations
  p result
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ConfigurationDiscoveryServiceApi->get_supported_operations: #{e}"
end
```

#### Using the get_supported_operations_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SupportedOperations>, Integer, Hash)> get_supported_operations_with_http_info

```ruby
begin
  # Gets information about the supported operations and features of the ISBM service provider. The purpose of this operation is to allow an application to be configured appropriately to communicate successfully with the service provider.
  data, status_code, headers = api_instance.get_supported_operations_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SupportedOperations>
rescue IsbmRestAdaptor::ApiError => e
  puts "Error when calling ConfigurationDiscoveryServiceApi->get_supported_operations_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**SupportedOperations**](SupportedOperations.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/xml

