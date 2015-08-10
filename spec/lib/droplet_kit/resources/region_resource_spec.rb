require 'spec_helper'

RSpec.describe DropletKit::RegionResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns a collection of regions' do
      body = api_fixture('regions/all')
      stub_do_api('/v2/regions').to_return(body: body)
      expected = DropletKit::RegionMapping.extract_collection(body, :read)

      expect(resource.all).to eq(expected)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) {'regions/all'}
      let(:api_path) {'/v2/regions'}
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/regions' }
      let(:method) { :get }
      let(:action) { :all }
    end
  end
end
