# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This gem links its version to that of the OpenO&M ISBM specification: the first two 
parts of the version number follows the OpenO&M ISBM specification and last part 
specifies a patch number of the gem.

## [Unreleased]
### Changed
- Contributed code from @mattys101 converted to standalone gem at Assetricity repository

### Planned
- High-level API to abstract from REST, SOAP, etc. and support drop-in replacement 
  of different interface types.
- Registration of the adaptor interface to allow multi-interface use, e.g., REST and
  SOAP being used side-by-side.

## [0.0.6] - 2021-07-29

* Updated to use the final release version of the OpenO&M ISBM v2 Specification and
  its official OpenAPI specification: https://www.openoandm.org/isbm/

## [0.0.5] - 2020-02-18

Made some changes according to discussion and revision of the specification:

* Revised message content: entire message data (topics, etc.) are encoded in HTTP body.
  * Previously, meta-data such as topics were encoded in the query string and headers
    with only the message content itself in the HTTP body.
* Channel URI is now URL encoded within one path segment instead of being incorporated
  into the URL as (possibly) multiple path segments, e.g.:
  * from: `http://example.com/channels/some/channel/URI/publication-sessions`
  * to:   `http://example.com/channels/%2Fsome%2Fchannel%2FURI/publication-sessions`

## [0.0.4]

* Added Notification Service

## [0.0.3]

* Added Provider Request Service API client
* Added Consumer Request Service API client

## [0.0.2]

* Implemented Consumer Publication Service API client

## [0.0.1]

* Initial framework generation
* Implemented base model
* Implemented Provider Publication Service API client
