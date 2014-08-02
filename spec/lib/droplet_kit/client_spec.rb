require 'spec_helper'

RSpec.describe DropletKit::Client do
  subject(:client) { DropletKit::Client.new(access_token: 'bunk') }

  describe '#initialize' do
    it 'initializes with an access token' do
      client = DropletKit::Client.new(access_token: 'my-token')
      expect(client.access_token).to eq('my-token')
    end
  end

  describe '#connection' do
    it 'populates the authorization header correctly' do
      expect(client.connection.headers['Authorization']).to eq("Bearer #{client.access_token}")
    end

    it 'sets the content type' do
      expect(client.connection.headers['Content-Type']).to eq("application/json")
    end
  end
end