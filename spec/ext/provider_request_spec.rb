require 'spec_helper'

describe IsbmRestAdaptor::ProviderRequest, :vcr do
  include_context 'client_config'
  let(:client) { IsbmRestAdaptor::ProviderRequest.new(client_config: client_config) }

  context 'with invalid arguments' do
    describe '#open_session' do
      let(:uri) { '/Test' }
      let(:topic) { 'topics' }

      it 'raises error with no URI' do
        expect { client.open_session(nil, topic) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent URI' do
        expect { client.open_session('/DoesNotExist', topic) }.to raise_error IsbmAdaptor::ChannelFault
      end

      it 'raises error with no topics' do
        expect { client.open_session(uri, nil) }.to raise_error ArgumentError
      end

      describe 'with filter expression' do
        let(:invalid_filter) { {expression: nil, language: 'XPath', language_version: '1.0'} }
        let(:invalid_language) { {expression: '/*', language: nil, language_version: '1.0'} }
        let(:invalid_namespaces) {
          { 
            expression: '/*', language: 'XPath', language_version: '1.0',
            namespaces: [{'ccom' => 'http://www.mimosa.org/ccom4'}, {'ccom' => 'http://www.w3.org/2001/XMLSchema'}]
          } 
        }

        it 'raises error when no expression string' do
          expect { client.open_session(uri, topic, filter_expression: invalid_filter) }.to raise_error ArgumentError
        end

        it 'raises error when no expression language' do
          expect { client.open_session(uri, topic, filter_expression: invalid_language) }.to raise_error ArgumentError
        end
        
        it 'raises error when duplicate namespace prefix' do
          expect { client.open_session(uri, topic, filter_expression: invalid_namespaces) }.to raise_error IsbmAdaptor::NamespaceFault
        end
      end

      describe 'on channel' do
        let(:channel_client) { IsbmRestAdaptor::ChannelManagement.new(client_config: client_config) }
        before { channel_client.create_channel('/TestWrongType', :publication) }
        it 'raises error with mismatched channel type' do
          expect { client.open_session('/TestWrongType', topic) }.to raise_error IsbmAdaptor::OperationFault
        end
        after { channel_client.delete_channel('/TestWrongType') }
      end
    end

    describe '#read_request' do
      it 'raises error with no session id' do
        expect { client.read_request(nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.read_request('not_real_session_id') }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#remove_request' do
      it 'raises error with no session id' do
        expect { client.remove_request(nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.remove_request('not_real_session_id') }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#post_response' do
      let(:session_id) { 'session id' }
      let(:request_message_id) { 'request message id' }
      let(:content) { '<test/>' }
      let(:invalid_content) { '<test>' }

      it 'raises error with no session id' do
        expect { client.post_response(nil, request_message_id, content) }.to raise_error ArgumentError
      end

      it 'raises error with no request message id' do
        expect { client.post_response(session_id, nil, content) }.to raise_error ArgumentError
      end

      it 'raises error with no content' do
        expect { client.post_response(session_id, request_message_id, nil) }.to raise_error ArgumentError
      end

      it 'raises error with invalid content' do
        expect { client.post_response(session_id, request_message_id, invalid_content) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.post_response('not_real_session_id', request_message_id, content) }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#close_session' do
      it 'raises error with no session id' do
        expect { client.close_session(nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.close_session('not_real_session_id') }.to raise_error IsbmAdaptor::SessionFault
      end
    end
  end

  context 'with valid arguments' do
    let(:uri) { '/Test' }
    let(:type) { :request }
    let(:topic) { 'topic' }
    let(:channel_client) { IsbmRestAdaptor::ChannelManagement.new(client_config: client_config) }
    before { channel_client.create_channel(uri, type) }

    let!(:provider_session_id) { client.open_session(uri, topic) }

    describe '#open_session' do
      it 'returns a session id' do
        expect(provider_session_id).not_to be_nil
      end

      context 'multiple topic array' do
        let(:topic) { ['topic', 'another topic'] }
        it 'returns a session id' do
          expect(provider_session_id).not_to be_nil
        end
      end
    end

    context 'with consumer' do
      let(:consumer_client) { IsbmRestAdaptor::ConsumerRequest.new(client_config: client_config) }
      let(:consumer_session_id) { consumer_client.open_session(uri) }
      
      describe '#read_request (XML Content)' do
        let(:content) { File.read(File.expand_path('../fixtures/ccom.xml', File.dirname(__FILE__))) }
        before { consumer_client.post_request(consumer_session_id, content, topic) }
        let(:request) { client.read_request(provider_session_id) }

        it 'returns a valid request message' do
          expect(request.id).not_to be_nil
          expect(request.topics.first).to eq topic
          expect(request.content.root.name).to eq 'CCOMData'
          expect(request.media_type).to eq 'application/xml'
          expect(request.content_encoding).to be_nil
        end

        # For when XML content is extracted from XML wrapper
        it 'copies namespaces to content root' do
          doc = Nokogiri::XML(request.content.to_xml)
          expect(doc.namespaces.values).to include 'http://www.w3.org/2001/XMLSchema-instance'
          expect(doc.namespaces.values).to include 'http://www.mimosa.org/ccom4'
        end
  
        describe '#remove_request' do
          before { client.remove_request(provider_session_id) }
  
          it 'removes the request from the queue' do
            expect(request).to be_nil
          end
        end

        describe '#post_response' do
          let(:json_content) { {ccomData: [{entity: {:'@@type' => 'Asset', uuid: 'C013C740-19F5-11E1-92B7-6B8E4824019B'}}]} }
          let(:json_string) { "{\"ccomData\":[{\"entity\":{\"@@type\":\"Asset\",\"uuid\":\"C013C740-19F5-11E1-92B7-6B8E4824019B\"}}]}" }
          let(:string_content) { 'plain text string' }
          let(:binary_content) { 
            {media_type: 'application/xml', content_encoding: 'base64', content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='}
          }
          let(:response_message_id) { client.post_response(provider_session_id, request.id, content) }

          it 'returns a response message id' do
            expect(response_message_id).not_to be_nil
          end

          it 'can accept json content (as a Hash)' do
            expect(client.post_response(provider_session_id, request.id, json_content)).not_to be_nil
          end
    
          it 'can accept json content (as a String)' do
            expect(client.post_response(provider_session_id, request.id, json_string)).not_to be_nil
          end
    
          it 'can accept binary content' do
            expect(client.post_response(provider_session_id, request.id, binary_content)).not_to be_nil
          end
    
          it 'can accept plain text content' do
            expect(client.post_response(provider_session_id, request.id, string_content)).not_to be_nil
          end
        end
      end

      describe '#read_request (JSON content)' do
        let(:content) { {ccomData: [{entity: {:'@@type' => 'Asset', uuid: 'C013C740-19F5-11E1-92B7-6B8E4824019B'}}]} }
        before { consumer_client.post_request(consumer_session_id, content, topic) }

        let(:request) { client.read_request(provider_session_id) }

        it 'returns a valid request message' do
          expect(request.id).not_to be_nil
          expect(request.topics.first).to eq topic
          expect(request.content).to eq content
          expect(request.media_type).to eq 'application/json'
          expect(request.content_encoding).to be_nil
        end

        after { client.remove_request(provider_session_id) }
      end

      describe '#read_request (String content)' do
        let(:content) { 'plain text string' }
        before { consumer_client.post_request(consumer_session_id, content, topic) }

        let(:request) { client.read_request(provider_session_id) }

        it 'returns a valid request message' do
          expect(request.id).not_to be_nil
          expect(request.topics.first).to eq topic
          expect(request.content).to eq content
          expect(request.media_type).to eq 'text/plain'
          expect(request.content_encoding).to be_nil
        end

        after { client.remove_request(provider_session_id) }
      end

      describe '#read_request (Binary content)' do
        let(:content) { 
          {media_type: 'application/xml', content_encoding: 'base64', content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='}
        }
        before { consumer_client.post_request(consumer_session_id, content, topic) }

        let(:request) { client.read_request(provider_session_id) }

        it 'returns a valid request message' do
          expect(request.id).not_to be_nil
          expect(request.topics.first).to eq topic
          expect(request.content).to eq content[:content]
          expect(request.media_type).to eq content[:media_type]
          expect(request.content_encoding).to eq content[:content_encoding]
        end

        after { client.remove_request(provider_session_id) }
      end

      after { consumer_client.close_session(consumer_session_id) }
    end

    after do
      client.close_session(provider_session_id)
      channel_client.delete_channel(uri)
    end
  end
end
