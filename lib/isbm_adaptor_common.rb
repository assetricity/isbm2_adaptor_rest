unless defined? IsbmAdaptor::Version
  # Non-updated ISBM v1 SOAP adaptor gem has been included
  # TODO: work around it or issue a warning/error?
end

require 'isbm_adaptor_common/version'
require 'isbm_adaptor_common/channel'
require 'isbm_adaptor_common/exceptions'

module IsbmAdaptor
end