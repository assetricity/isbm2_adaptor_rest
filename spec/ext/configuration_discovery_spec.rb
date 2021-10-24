require 'spec_helper'

describe ISBMRestAdaptor::ConfigurationDiscovery, :vcr do
  include_context 'client_config'
  let(:client) { ISBMRestAdaptor::ConfigurationDiscovery.new(client_config: client_config) }

  context 'when security token is valid' do
    describe '#get_security_details' do
      let(:result) { client.get_security_details() }

      it 'returns valid security details' do
        expect(result).to have_key(:isTLSEnabled)
        expect(result).to have_key(:isSecurityTokenRequired)
        expect(result).to have_key(:isSecurityTokenEncryptionEnabled)
        expect(result).to have_key(:isCertificateRequired)
        expect(result).to have_key(:isRBACEnabled)
        expect(result).to have_key(:isKeyManagementServiceEnabled)
        expect(result).to have_key(:isEndToEndMessageEncryptionEnabled)
      end
    end

    describe '#get_supported_operations' do
      let(:xpath_language) { {applicableMediaTypes: ["application/xml","text/xml"], languageName: "XPath", languageVersion: "1.0"} }
      let(:json_language) { {applicableMediaTypes: ["application/json"], languageName:"JSONPath", languageVersion: "com.jayway.jsonpath:json-path:2.4.0"} }
      let(:soap_auth_scheme) { {namespaceName: "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd", schemaLocation: "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"} }
      let(:rest_auth_scheme) { {schemeName: "Basic", schemeInfoUrl: "https://tools.ietf.org/html/rfc7617"} }
      let(:result) { client.get_supported_operations() }

      it 'returns valid operations and features details' do
        expect(result).to have_key(:isXMLFilteringEnabled)
        expect(result).to have_key(:isJSONFilteringEnabled)
        expect(result).to have_key(:supportedContentFilteringLanguages)
        expect(result).to have_key(:supportedAuthentications)
        expect(result).to have_key(:securityLevelConformance)
        expect(result).to have_key(:isDeadLetteringEnabled)
        expect(result).to have_key(:isChannelCreationEnabled)
        expect(result).to have_key(:isOpenChannelSecuringEnabled)
        expect(result).to have_key(:isWhitelistRequired)
        expect(result).to have_key(:defaultExpiryDuration)
        expect(result).to have_key(:additionalInformationURL)
        expect(result[:supportedContentFilteringLanguages]).to have_key(:contentFilteringLanguages)
        expect(result[:supportedContentFilteringLanguages][:contentFilteringLanguages].size).to eq(2)
        expect(result[:supportedContentFilteringLanguages][:contentFilteringLanguages][0]).to eq(xpath_language)
        expect(result[:supportedContentFilteringLanguages][:contentFilteringLanguages][1]).to eq(json_language)
        expect(result[:supportedAuthentications]).to have_key(:soapSupportedTokenSchemas)
        expect(result[:supportedAuthentications]).to have_key(:restSupportedAuthenticationSchemes)
        expect(result[:supportedAuthentications][:soapSupportedTokenSchemas]).to eq([soap_auth_scheme])
        expect(result[:supportedAuthentications][:restSupportedAuthenticationSchemes]).to eq([rest_auth_scheme])
      end
    end
  end

  context 'when invalid security token is used' do
    describe '#get_security_details' do
      it 'raises SecurityTokenFault (unauthorised access)' do
        expect { client.get_security_details(auth_username: 'fake', auth_password: 'fake') }.to raise_error IsbmAdaptor::SecurityTokenFault
      end
    end
    
    describe '#get_supported_operations' do
      it 'raises UnknownFault as operation should always succeed' do
        # Note the cassette has been manually modified to cause this error.
        expect { client.get_supported_operations(auth_username: 'fake', auth_password: 'fake') }.to raise_error IsbmAdaptor::UnknownFault
      end
    end
  end

end
