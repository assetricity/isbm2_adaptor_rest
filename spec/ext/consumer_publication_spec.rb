describe IsbmRestAdaptor::ConsumerPublication, :vcr do
  include_context 'client_config'
  let(:client) { IsbmRestAdaptor::ConsumerPublication.new(client_config: client_config) }

  context 'with invalid arguments' do
    describe '#open_session' do
      let(:uri) { '/Test' }
      let(:topic) { 'topic' }

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
        before { channel_client.create_channel('/TestWrongType', :request) }
        it 'raises error with mismatched channel type' do
          expect { client.open_session('/TestWrongType', topic) }.to raise_error IsbmAdaptor::OperationFault
        end
        after { channel_client.delete_channel('/TestWrongType') }
      end
    end

    describe '#read_publication' do
      it 'raises error with no session id' do
        expect { client.read_publication(nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.read_publication('not_real_session_id') }.to raise_error IsbmAdaptor::SessionFault
      end
    end

    describe '#remove_publication' do
      it 'raises error with no session id' do
        expect { client.remove_publication(nil) }.to raise_error ArgumentError
      end

      it 'raises error with non-existent session id' do
        expect { client.remove_publication('not_real_session_id') }.to raise_error IsbmAdaptor::SessionFault
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
    let(:type) { :publication }
    let(:topic) { 'topic' }
    let(:channel_client) { IsbmRestAdaptor::ChannelManagement.new(client_config: client_config) }
    before { channel_client.create_channel(uri, type) }

    let(:filter) { 
      { 
        expression: '//ccom:Entity', language: 'XPath', language_version: '1.0', 
        applicable_media_types: ['application/xml'], 
        namespaces: [{'ccom' => 'http://www.mimosa.org/ccom4'}]
      } 
    }

    let!(:consumer_session_id) { client.open_session(uri, topic, filter_expression: [filter]) }

    describe '#open_session' do
      it 'returns a session id' do
        expect(consumer_session_id).not_to be_nil
      end

      context 'multiple topic array' do
        let(:topic) { ['topic', 'another topic'] }
        it 'returns a session id' do
          expect(consumer_session_id).not_to be_nil
        end
      end
    end

    context 'with provider' do
      let(:provider_client) { IsbmRestAdaptor::ProviderPublication.new(client_config: client_config) }
      let(:provider_session_id) { provider_client.open_session(uri) }
      
      describe '#read_publication (XML content)' do
        let(:content) { File.read(File.expand_path('../fixtures/ccom.xml', File.dirname(__FILE__))) }
        before { provider_client.post_publication(provider_session_id, content, topic) }

        let(:message) { client.read_publication(consumer_session_id) }

        it 'returns a valid message' do
          expect(message.id).not_to be_nil
          expect(message.topics.first).to eq topic
          expect(message.content.root.name).to eq 'CCOMData'
          expect(message.media_type).to eq 'application/xml'
          expect(message.content_encoding).to be_nil
        end

        # For when XML content is extracted from XML wrapper
        it 'copies namespaces to content root' do
          doc = Nokogiri::XML(message.content.to_xml)
          expect(doc.namespaces.values).to include 'http://www.w3.org/2001/XMLSchema-instance'
          expect(doc.namespaces.values).to include 'http://www.mimosa.org/ccom4'
        end

        describe '#remove_publication' do
          before { client.remove_publication(consumer_session_id) }
          let(:message2) { client.read_publication(consumer_session_id) }

          it 'returns nil when there are no more messages' do
            expect(message2).to be_nil
          end
        end
      end

      describe '#read_publication (JSON content)' do
        let(:content) { {ccomData: [{entity: {:'@@type' => 'Asset', uuid: 'C013C740-19F5-11E1-92B7-6B8E4824019B'}}]} }
        before { provider_client.post_publication(provider_session_id, content, topic) }

        let(:message) { client.read_publication(consumer_session_id) }

        it 'returns a valid message' do
          expect(message.id).not_to be_nil
          expect(message.topics.first).to eq topic
          expect(message.content).to eq content
          expect(message.media_type).to eq 'application/json'
          expect(message.content_encoding).to be_nil
        end

        after { client.remove_publication(consumer_session_id) }
      end

      describe '#read_publication (String content)' do
        let(:content) { 'plain text string' }
        before { provider_client.post_publication(provider_session_id, content, topic) }

        let(:message) { client.read_publication(consumer_session_id) }

        it 'returns a valid message' do
          expect(message.id).not_to be_nil
          expect(message.topics.first).to eq topic
          expect(message.content).to eq content
          expect(message.media_type).to eq 'text/plain'
          expect(message.content_encoding).to be_nil
        end

        after { client.remove_publication(consumer_session_id) }
      end

      describe '#read_publication (Binary content)' do
        let(:content) { 
          {media_type: 'application/xml', content_encoding: 'base64', content: 'PHNvbWVYbWw+VGhpcyBpcyBYTUwgY29udGVudCBpbiBKU09OPC9zb21lWG1sPg=='}
        }
        before { provider_client.post_publication(provider_session_id, content, topic) }

        let(:message) { client.read_publication(consumer_session_id) }

        it 'returns a valid message' do
          expect(message.id).not_to be_nil
          expect(message.topics.first).to eq topic
          expect(message.content).to eq content[:content]
          expect(message.media_type).to eq content[:media_type]
          expect(message.content_encoding).to eq content[:content_encoding]
        end

        after { client.remove_publication(consumer_session_id) }
      end

      after { provider_client.close_session(provider_session_id) }
    end

    after do
      client.close_session(consumer_session_id)
      channel_client.delete_channel(uri)
    end
  end
end
