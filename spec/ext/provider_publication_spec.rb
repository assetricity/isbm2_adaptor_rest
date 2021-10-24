require 'spec_helper'

describe IsbmRestAdaptor::ProviderPublication, :vcr do
  include_context 'client_config'
  let(:client) { IsbmRestAdaptor::ProviderPublication.new(client_config: client_config) }

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
        before { channel_client.create_channel('/TestWrongType', :request) }
        it 'raises error with mismatched channel type' do
          expect { client.open_session('/TestWrongType') }.to raise_error IsbmAdaptor::OperationFault
        end
        after { channel_client.delete_channel('/TestWrongType') }
      end
    end

    describe '#post_publication' do
      let(:session_id) { 'session id' }
      let(:content) { '<test/>' }
      let(:invalid_content) { '<test>' }
      let(:topic) { 'topic' }
      let(:invalid_json) { '{"test":' }
      let(:invalid_object) { Object.new }

      it 'raises error with no session id' do
        expect { client.post_publication(nil, content, topic) }.to raise_error ArgumentError
      end

      it 'raises error with no content' do
        expect { client.post_publication(session_id, nil, topic) }.to raise_error ArgumentError
      end

      it 'raises error with invalid xml content' do
        expect { client.post_publication(session_id, invalid_content, topic) }.to raise_error ArgumentError
      end

      it 'raises error with invalid json content' do
        expect { client.post_publication(session_id, invalid_json, topic) }.to raise_error ArgumentError
      end

      it 'raises error with invalid object content' do
        expect { client.post_publication(session_id, invalid_object, topic) }.to raise_error ArgumentError
      end

      it 'raises error with no topics' do
        expect { client.post_publication(session_id, content, nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.post_publication('not_real_session_id', content, topic) }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#expire_publication' do
      let(:session_id) { 'session id' }
      let(:message_id) { 'message id' }

      it 'raises error with no session id' do
        expect { client.expire_publication(nil, message_id) }.to raise_error ArgumentError
      end

      it 'raises error with no message id' do
        expect { client.expire_publication(session_id, nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.expire_publication('not_real_session_id', message_id) }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe 'close publication session' do
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
    let(:type) { :publication }
    let(:channel_client) { IsbmRestAdaptor::ChannelManagement.new(client_config: client_config) }
    before { channel_client.create_channel(uri, type) }

    let(:session_id) { client.open_session(uri) }

    describe '#open_session' do
      it 'returns a session id' do
        expect(session_id).not_to be_nil
        expect(session_id).not_to be_empty
      end
    end

    describe 'posting' do
      let(:content) { File.read(File.expand_path('../fixtures/ccom.xml', File.dirname(__FILE__))) }
      let(:topic) { 'topic' }
      let(:message_id) { client.post_publication(session_id, content, topic) }
      
      describe '#post_publication' do
        let(:json_content) { {ccomData: [{entity: {'@@type': 'Asset', uuid: 'C013C740-19F5-11E1-92B7-6B8E4824019B'}}]} }
        let(:json_string) { "{\"ccomData\":[{\"entity\":{\"@@type\":\"Asset\",\"uuid\":\"C013C740-19F5-11E1-92B7-6B8E4824019B\"}}]}" }
        let(:string_content) { 'plain text string' }
        let(:binary_content) { 
          {media_type: 'application/xml', content_encoding: 'base64', content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='}
        }

        it 'returns a message id' do
          expect(message_id).not_to be_nil
        end

        it 'can accept json content (as a Hash)' do
          expect(client.post_publication(session_id, json_content, topic)).not_to be_nil
        end

        it 'can accept json content (as a String)' do
          expect(client.post_publication(session_id, json_string, topic)).not_to be_nil
        end

        it 'can accept binary content' do
          expect(client.post_publication(session_id, binary_content, topic)).not_to be_nil
        end

        it 'can accept plain text content' do
          expect(client.post_publication(session_id, string_content, topic)).not_to be_nil
        end

        it 'can use a single topic string' do
          expect { client.post_publication(session_id, content, topic) }.not_to raise_error
        end

        it 'can use a multiple topic array' do
          expect { client.post_publication(session_id, content, [topic]) }.not_to raise_error
        end

        let(:expiry) { IsbmAdaptor::Duration.new(hours: 1) }
        it 'raises no error with expiry' do
          expect { client.post_publication(session_id, content, topic, expiry) }.not_to raise_error
        end
      end

      describe '#expire_publication' do
        it 'raises no error' do
          expect { client.expire_publication(session_id, message_id) }.not_to raise_error
        end
      end
    end

    after do
      client.close_session(session_id)
      channel_client.delete_channel(uri)
    end
  end
end
