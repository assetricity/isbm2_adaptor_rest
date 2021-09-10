# ISBMRestAdaptor::MetadataApi

All URIs are relative to *http://localhost:80*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_metadata**](MetadataApi.md#get_metadata) | **GET** /api | Get metadata from the root of the API |


## get_metadata

> Object get_metadata

Get metadata from the root of the API

### Examples

```ruby
require 'time'
require 'isbm2_adaptor_rest'

api_instance = ISBMRestAdaptor::MetadataApi.new

begin
  # Get metadata from the root of the API
  result = api_instance.get_metadata
  p result
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling MetadataApi->get_metadata: #{e}"
end
```

#### Using the get_metadata_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(Object, Integer, Hash)> get_metadata_with_http_info

```ruby
begin
  # Get metadata from the root of the API
  data, status_code, headers = api_instance.get_metadata_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => Object
rescue ISBMRestAdaptor::ApiError => e
  puts "Error when calling MetadataApi->get_metadata_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

**Object**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

