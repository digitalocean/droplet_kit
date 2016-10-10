require 'spec_helper'

RSpec.describe DropletKit::Client do
  subject(:client) { DropletKit::Client.new(access_token: 'bunk') }

  describe '#initialize' do
    it 'initializes with an access token' do
      client = DropletKit::Client.new(access_token: 'my-token')
      expect(client.access_token).to eq('my-token')
    end

    it 'allows string option keys for the client' do
      client = DropletKit::Client.new('access_token' => 'my-token')
      expect(client.access_token).to eq('my-token')
    end
  end

  describe "#method_missing" do
    context "called with an existing method" do
      it { expect{ client.actions}.to_not raise_error }
    end

    context "called with a missing method" do
      it { expect{client.this_is_wrong}.to raise_error(NoMethodError) }
    end
  end

  describe '#connection' do
    module AcmeApp
      class CustomLogger < Faraday::Middleware
      end
    end

    it 'populates the authorization header correctly' do
      expect(client.connection.headers['Authorization']).to eq("Bearer #{client.access_token}")
    end

    it 'sets the content type' do
      expect(client.connection.headers['Content-Type']).to eq("application/json")
    end

    it 'allows access to faraday instance' do
      client.connection.use AcmeApp::CustomLogger
      expect(client.connection.builder.handlers).to include(AcmeApp::CustomLogger)
    end
  end

end

