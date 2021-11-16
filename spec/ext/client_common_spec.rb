require 'spec_helper'
require 'isbm2_adaptor_rest/ext/client_common'

class ClientStub
  include IsbmRestAdaptor::ClientCommon

  def client_side_validation?
    true
  end
end

describe IsbmRestAdaptor::ClientCommon do
  let(:client) { ClientStub.new }
  
  context 'when building a message' do
    let(:json_content) { {example: 'content'} }
    let(:xml_content) { Nokogiri::XML('<example>Content</example>') }

    describe 'with Hash content' do
      let(:content) { json_content }

      it 'detects the media_type as JSON (nil) if no :content, :media_type keys present and JSON target' do
        expect(client.build_message_content(content).media_type).to be_nil
      end

      it 'normalises media_type if explict :content Hash and matching target' do
        expect(client.build_message_content({content: content, media_type: 'application/json'}).media_type).to be_nil
      end

      it 'normalises media_type if explict :content Hash and matching target string content' do
        expect(client.build_message_content({content: content.to_json, media_type: 'application/json'}).media_type).to be_nil
      end
      
      it 'detects text media_type if :content Hash but no specified media_type' do
        expect(client.build_message_content({content: 'Some content'}).media_type).to eq('text/plain')
      end
      
      it 'detects xml media_type if :content Hash but no specified media_type' do
        expect(client.build_message_content({content: xml_content.root.to_xml}).media_type).to eq('application/xml')
      end

      it 'detects xml media_type if :content Hash with XML object but no specified media_type' do
        expect(client.build_message_content({content: xml_content}).media_type).to eq('application/xml')
      end

      it 'raises argument error if JSON string is invalid' do
        expect { client.build_message_content({content: json_content.to_json.chomp[0..-2]}) }.to raise_error ArgumentError
      end

      it 'raises argument error if XML string is invalid' do
        expect { client.build_message_content({content: xml_content.to_xml.chomp[0..-2]}) }.to raise_error ArgumentError
      end
    end

    describe 'with String content' do
      let(:content) { 'a basic string' }

      it 'detects plain text media_type for ordinary string' do
        expect(client.build_message_content(content).media_type).to eq('text/plain')
      end
      
      it 'detects JSON content if string is valid JSON' do
        expect(client.build_message_content(json_content.to_json).media_type).to be_nil
      end
      
      it 'detects XML content if string is valid XML' do
        expect(client.build_message_content(xml_content.root.to_xml).media_type).to eq('application/xml')
      end

      it 'raises argument error if JSON string is invalid' do
        expect { client.build_message_content(json_content.to_json.chomp[0..-2]) }.to raise_error ArgumentError
      end

      it 'raises argument error if XML string is invalid' do
        expect { client.build_message_content(xml_content.to_xml.chomp[0..-2]) }.to raise_error ArgumentError
      end
    end

    describe 'with XML content' do
      let(:content) { xml_content }

      it 'detects XML media_type' do
        expect(client.build_message_content(content).media_type).to eq('application/xml')
      end
    end
  end
end