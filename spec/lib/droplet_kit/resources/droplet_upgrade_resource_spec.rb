require 'spec_helper'

RSpec.describe DropletKit::DropletUpgradeResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns a collection of Droplet upgrades' do
      body = api_fixture('droplet_upgrades/all')
      stub_do_api('/v2/droplet_upgrades').to_return(body: body)
      expected = DropletKit::DropletUpgradeMapping.extract_collection(body, :read)

      expect(resource.all).to eq(expected)
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/droplet_upgrades' }
      let(:method) { :get }
      let(:action) { :all }
    end
  end
end
