=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0
Contact: info@mimosa.org
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 5.2.0

=end

require 'spec_helper'
require 'json'
require 'date'

# Unit tests for ISBMRestAdaptor::ParameterFault
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'ParameterFault' do
  before do
    # run before each test
    @instance = ISBMRestAdaptor::ParameterFault.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of ParameterFault' do
    it 'should create an instance of ParameterFault' do
      expect(@instance).to be_instance_of(ISBMRestAdaptor::ParameterFault)
    end
  end
  describe 'test attribute "faultstring"' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end