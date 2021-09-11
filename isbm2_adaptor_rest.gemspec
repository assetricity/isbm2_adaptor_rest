# -*- encoding: utf-8 -*-

=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0
Contact: info@mimosa.org
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 5.2.0

=end

$:.push File.expand_path("../lib", __FILE__)
require "isbm2_adaptor_rest/version"

Gem::Specification.new do |s|
  s.name        = "isbm2_adaptor_rest"
  s.version     = ISBMRestAdaptor::VERSION
  s.authors     = ["Assetricity"]
  s.email       = ["info@assetricity.com"]
  s.homepage    = "https://github.com/assetricity/isbm2_adaptor_rest"
  s.summary     = "Ruby client API for the ISBM v2 specification REST interface."
  s.description = "ISBM v2 Adaptor (REST) provides a Ruby client API for the OpenO&amp;M ISBM v2 specification REST interface.
It has been generated from the OpenAPI spec of the API using openapi-generator and subsequently tailored."
  s.license     = "MIT"
  s.required_ruby_version = ">= 1.9.3"

  # XXX: Short term to not update the following dependencies to preserve 1.9.3 compatibility
  
  s.add_runtime_dependency 'typhoeus', '~> 1.0', '>= 1.0.1'
  s.add_runtime_dependency 'concurrent-ruby', '~> 1.1', '>= 1.1.5'
  
  # XXX: Short term to not update the following dependencies to preserve 1.9.3 compatibility
  #      rake relaxed as needs to be < 11.0.1 for 1.9.3 compatibility
  
  s.add_development_dependency 'rake'#, '~> 12.0', '>= 12.3.3'
  s.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'
  s.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.1'
  s.add_development_dependency 'webmock', '~> 1.24', '>= 1.24.3'

  # TODO ensure only desired files are included
  s.files = Dir['{docs/*,lib/**/*}'] + 
    %w(CHANGELOG.md config.ru Gemfile isbm2_adaptor_rest.gemspec LICENSE Rakefile README.md)
  s.test_files    = `find spec/*`.split("\n")
  s.executables   = []
  s.require_paths = ["lib"]
end