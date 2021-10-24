require 'spec_helper'

describe IsbmRestAdaptor::ConsumerRequest, :vcr do
  include_context 'client_config'
  let(:client) { IsbmRestAdaptor::ConsumerRequest.new(client_config: client_config) }

  context 'with invalid arguments' do
    describe '#open_session' do
      it 'raises error with no URI' do
        expect { client.open_session(nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent URI' do
        expect { client.open_session('/DoesNotExist') }.to raise_error IsbmAdaptor::ChannelFault
      end

      describe 'on channel' do
        let(:channel_client) { IsbmRestAdaptor::ChannelManagement.new(client_config: client_config) }
        before { channel_client.create_channel('/TestWrongType', :publication) }
        it 'raises error with mismatched channel type' do
          expect { client.open_session('/TestWrongType') }.to raise_error IsbmAdaptor::OperationFault
        end
        after { channel_client.delete_channel('/TestWrongType') }
      end
    end

    describe '#post_request' do
      let(:session_id) { 'session id' }
      let(:content) { '<test/>' }
      let(:invalid_content) { '<test>' }
      let(:topic) { 'topic' }
      let(:invalid_json) { '{"test":' }
      let(:invalid_object) { Object.new }

      it 'raises error with no session id' do
        expect { client.post_request(nil, content, topic) }.to raise_error ArgumentError
      end

      it 'raises error with no content' do
        expect { client.post_request(session_id, nil, topic) }.to raise_error ArgumentError
      end

      it 'raises error with invalid xml content' do
        expect { client.post_request(session_id, invalid_content, topic) }.to raise_error ArgumentError
      end

      it 'raises error with invalid json content' do
        expect { client.post_request(session_id, invalid_json, topic) }.to raise_error ArgumentError
      end

      it 'raises error with invalid object content' do
        expect { client.post_request(session_id, invalid_object, topic) }.to raise_error ArgumentError
      end

      it 'raises error with no topics' do
        expect { client.post_request(session_id, content, nil) }.to raise_error ArgumentError
      end

      it 'raises error with more than 1 topic' do
        expect { client.post_request(session_id, content, [topic, 'topic2']) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.post_request('not_real_session_id', content, topic) }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#expire_request' do
      let(:session_id) { 'session id' }
      let(:message_id) { 'message id' }

      it 'raises error with no session id' do
        expect { client.expire_request(nil, message_id) }.to raise_error ArgumentError
      end

      it 'raises error with no message id' do
        expect { client.expire_request(session_id, nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.expire_request('not_real_session_id', message_id) }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#read_response' do
      let(:session_id) { 'session id' }
      let(:request_message_id) { 'request message id' }

      it 'raises error with no session id' do
        expect { client.read_response(nil, request_message_id) }.to raise_error ArgumentError
      end

      it 'raises error with no request message id' do
        expect { client.read_response(session_id, nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.read_response('not_real_session_id', request_message_id) }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#remove_response' do
      let(:session_id) { 'session id' }
      let(:request_message_id) { 'request message id' }

      it 'raises error with no session id' do
        expect { client.remove_response(nil, request_message_id) }.to raise_error ArgumentError
      end

      it 'raises error with no request message id' do
        expect { client.remove_response(session_id, nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.remove_response('not_real_session_id', request_message_id) }.to raise_error IsbmAdaptor::SessionFault
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

    let(:consumer_session_id) { client.open_session(uri) }

    describe '#open_session' do
      it 'returns a session id' do
        expect(consumer_session_id).not_to be_nil
      end
    end

    describe '#post_request' do
      let(:content) { File.read(File.expand_path('../fixtures/ccom.xml', File.dirname(__FILE__))) }
      let(:json_content) { {ccomData: [{entity: {'@@type': 'Asset', uuid: 'C013C740-19F5-11E1-92B7-6B8E4824019B'}}]} }
      let(:json_string) { "{\"ccomData\":[{\"entity\":{\"@@type\":\"Asset\",\"uuid\":\"C013C740-19F5-11E1-92B7-6B8E4824019B\"}}]}" }
      let(:string_content) { 'plain text string' }
      let(:binary_content) { 
        {media_type: 'application/xml', content_encoding: 'base64', content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='}
      }
      let(:request_message_id) { client.post_request(consumer_session_id, content, topic) }
      
      it 'returns a request message id' do
        expect(request_message_id).not_to be_nil
      end

      it 'can accept json content (as a Hash)' do
        expect(client.post_request(consumer_session_id, json_content, topic)).not_to be_nil
      end

      it 'can accept json content (as a String)' do
        expect(client.post_request(consumer_session_id, json_string, topic)).not_to be_nil
      end

      it 'can accept binary content' do
        expect(client.post_request(consumer_session_id, binary_content, topic)).not_to be_nil
      end

      it 'can accept plain text content' do
        expect(client.post_request(consumer_session_id, string_content, topic)).not_to be_nil
      end

      let(:expiry) { IsbmAdaptor::Duration.new(hours: 1) }
      it 'raises no error with expiry' do
        expect { client.post_request(consumer_session_id, content, topic, expiry) }.not_to raise_error
      end
    end

    describe '#expire_request' do
      let(:content) { '<test/>' }
      let(:request_message_id) { client.post_request(consumer_session_id, content, topic) }

      it 'raises no error' do
        expect { client.expire_request(consumer_session_id, request_message_id) }.not_to raise_error
      end
    end

    context 'with provider' do
      let(:request_content) { '<test/>' }
      let(:provider_request_client) { IsbmRestAdaptor::ProviderRequest.new(client_config: client_config) }
      let!(:provider_session_id) { provider_request_client.open_session(uri, [topic]) }
      let!(:request_message_id) { client.post_request(consumer_session_id, request_content, topic) }
      
      describe '#read_response (XML Content)' do
        let(:content) { File.read(File.expand_path('../fixtures/ccom.xml', File.dirname(__FILE__))) }
        before { provider_request_client.post_response(provider_session_id, request_message_id, content) }
        let(:response) { client.read_response(consumer_session_id, request_message_id) }

        it 'returns a valid response message' do
          expect(response.id).not_to be_nil
          expect(response.topics.first).to be_blank
          expect(response.content.root.name).to eq 'CCOMData'
          expect(response.media_type).to eq 'application/xml'
          expect(response.content_encoding).to be_nil
        end

        # For when XML content is extracted from XML wrapper
        it 'copies namespaces to content root' do
          doc = Nokogiri::XML(response.content.to_xml)
          expect(doc.namespaces.values).to include 'http://www.w3.org/2001/XMLSchema-instance'
          expect(doc.namespaces.values).to include 'http://www.mimosa.org/ccom4'
        end

        describe '#remove_response' do
          before { client.remove_response(consumer_session_id, request_message_id) }
  
          it 'removes the response from the queue' do
            expect(response).to be_nil
          end
        end
      end

      describe '#read_response (JSON content)' do
        let(:content) { {ccomData: [{entity: {'@@type': 'Asset', uuid: 'C013C740-19F5-11E1-92B7-6B8E4824019B'}}]} }
        before { provider_request_client.post_response(provider_session_id, request_message_id, content) }

        let(:response) { client.read_response(consumer_session_id, request_message_id) }

        it 'returns a valid response message' do
          expect(response.id).not_to be_nil
          expect(response.topics.first).to be_blank
          expect(response.content).to eq content
          expect(response.media_type).to eq 'application/json'
          expect(response.content_encoding).to be_nil
        end

        after { client.remove_response(consumer_session_id, request_message_id) }
      end

      describe '#read_response (String content)' do
        let(:content) { 'plain text string' }
        before { provider_request_client.post_response(provider_session_id, request_message_id, content) }

        let(:response) { client.read_response(consumer_session_id, request_message_id) }

        it 'returns a valid response message' do
          expect(response.id).not_to be_nil
          expect(response.topics.first).to be_blank
          expect(response.content).to eq content
          expect(response.media_type).to eq 'text/plain'
          expect(response.content_encoding).to be_nil
        end

        after { client.remove_response(consumer_session_id, request_message_id) }
      end

      describe '#read_response (Binary content)' do
        let(:content) { 
          {media_type: 'application/xml', content_encoding: 'base64', content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='}
        }
        before { provider_request_client.post_response(provider_session_id, request_message_id, content) }

        let(:response) { client.read_response(consumer_session_id, request_message_id) }

        it 'returns a valid response message' do
          expect(response.id).not_to be_nil
          expect(response.topics.first).to be_blank
          expect(response.content).to eq content[:content]
          expect(response.media_type).to eq content[:media_type]
          expect(response.content_encoding).to eq content[:content_encoding]
        end

        after { client.remove_response(consumer_session_id, request_message_id) }
      end

      after { provider_request_client.close_session(provider_session_id) }
    end

    after do
      client.close_session(consumer_session_id)
      channel_client.delete_channel(uri)
    end
  end
end
