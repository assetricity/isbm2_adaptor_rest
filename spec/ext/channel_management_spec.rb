require 'spec_helper'

describe ISBMRestAdaptor::ChannelManagement, :vcr do
  let(:config) do
    # Load adaptor test configuration
    # TODO: should it be a single config file with different environments?
    #       or separate files named by the environment?
    ISBMRestAdaptor::Configuration.new do |config|
      settings = YAML.load_file(File.expand_path('../../config/settings.yml', File.dirname(__FILE__)))['test']
      config.scheme = settings['endpoints']['scheme']
      config.host = settings['endpoints']['host']
      config.base_path = settings['endpoints']['base_path']
      # Configure HTTP basic authorization: username_password
      config.username = settings['auth']['username']
      config.password = settings['auth']['password']
      # Options...
    end
  end

  let(:uri) { '/Test' }
  let(:type) { :publication }
  let(:description) { 'description' }
  let(:tokens) { [[:u1, :p1], [:u2, :p2]] }
  let(:client) { ISBMRestAdaptor::ChannelManagement.new(client_config: config) }

  context 'when invalid arguments' do
    describe '#create_channel' do
      it 'raises error with no URI' do
        expect { client.create_channel(nil, type) }.to raise_error ArgumentError
      end

      it 'raises error with no leading "/" in URI' do
        expect { client.create_channel(uri[1..-1], type) }.to raise_error IsbmAdaptor::ParameterFault
      end

      it 'raises error with no type' do
        expect { client.create_channel(uri, nil) }.to raise_error ArgumentError
      end

      it 'raises error with incorrect type' do
        expect { client.create_channel(uri, :invalid_channel_type) }.to raise_error ArgumentError
      end
    end

    describe '#add_security_tokens' do
      it 'raises error with no URI' do
        expect { client.add_security_tokens(nil, tokens) }.to raise_error ArgumentError
      end

      it 'raises error with no tokens' do
        expect { client.add_security_tokens(uri, nil) }.to raise_error ArgumentError
      end

      it 'raises channel fault when channel URI does not exist' do
        expect { client.add_security_tokens('/DoesNotExist', tokens) }.to raise_error IsbmAdaptor::ChannelFault
      end
    end

    describe '#remove_security_tokens' do
      it 'raises error with no URI' do
        expect { client.remove_security_tokens(nil, tokens) }.to raise_error ArgumentError
      end

      it 'raises error with no tokens' do
        expect { client.remove_security_tokens(uri, nil) }.to raise_error ArgumentError
      end

      it 'raises channel fault when channel URI does not exist' do
        expect { client.remove_security_tokens('/DoesNotExist', tokens) }.to raise_error IsbmAdaptor::ChannelFault
      end
    end

    describe '#delete_channel' do
      it 'raises error with no URI' do
        expect { client.delete_channel(nil) }.to raise_error ArgumentError
      end

      it 'raises channel fault when channel URI does not exist' do
        expect { client.delete_channel('/DoesNotExist') }.to raise_error IsbmAdaptor::ChannelFault
      end
    end

    describe '#get_channel' do
      it 'raises error with no URI' do
        expect { client.get_channel(nil) }.to raise_error ArgumentError
      end

      it 'raises channel fault when channel URI does not exist' do
        expect { client.get_channel('/DoesNotExist') }.to raise_error IsbmAdaptor::ChannelFault
      end
    end
  end

  context 'when create with valid arguments' do
    describe '#create_channel' do
      let(:channel) { client.create_channel(uri, type, description: description, tokens: tokens) }
      it 'creates a valid channel' do
        expect(channel.uri).to eq uri
        expect(channel.type).to eq type.to_s.capitalize
        expect(channel.description).to eq description
      end
    end

    after { client.delete_channel(uri) }
  end

  context 'when valid arguments' do
    before { client.create_channel(uri, type, description: description, tokens: tokens) }

    describe '#create_channel' do
      it 'raises channel fault on duplicate uri' do
        expect { client.create_channel(uri, type, description: description, tokens: tokens) }.to raise_error IsbmAdaptor::ChannelFault
      end
    end

    describe '#add_security_tokens' do
      it 'does not raise error' do
        expect { client.add_security_tokens(uri, tokens) }.not_to raise_error
      end
    end
    
    describe '#add_security_tokens disallowed' do
      let(:open_uri) { '/TestOpenChannel' }
      before { channel = client.create_channel(open_uri, type, description: description, tokens: nil) }
      it 'raises operation fault ' do
        expect { client.add_security_tokens(open_uri, tokens) }.to raise_error IsbmAdaptor::OperationFault
      end
      after { client.delete_channel(open_uri) }
    end

    describe '#remove_security_tokens' do
      before { client.add_security_tokens(uri, tokens) }
      it 'does not raise error' do
        expect { client.remove_security_tokens(uri, tokens) }.not_to raise_error
      end

      it 'raises security token fault if any token is invalid' do
        invalid_tokens = tokens + [['invalid', 'invalid']]
        expect { client.remove_security_tokens(uri, invalid_tokens) }.to raise_error IsbmAdaptor::SecurityTokenFault
      end
    end

    describe '#get_channel' do
      let(:channel) { client.get_channel(uri) }
      it 'returns a valid channel' do
        expect(channel.uri).to eq uri
        expect(channel.type).to eq type.to_s.capitalize
        expect(channel.description).to eq description
      end
    end

    describe '#get_channels' do
      let(:channels) { client.get_channels }
      it 'returns an array of valid channels' do
        expect(channel = channels.find { |channel| channel.uri == uri }).not_to be_nil
        expect(channel.type).to eq type.to_s.capitalize
        expect(channel.description).to eq description
      end
    end

    after { client.delete_channel(uri) }
  end
end
