shared_context 'resources' do
  let(:client) { DropletKit::Client.new(access_token: 'bunk-token') }
  let(:connection) { client.connection }
end