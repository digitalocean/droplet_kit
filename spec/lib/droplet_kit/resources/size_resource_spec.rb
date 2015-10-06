require 'spec_helper'

RSpec.describe DropletKit::SizeResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns a collection of regions' do
      body = api_fixture('sizes/all')
      stub_do_api('/v2/sizes').to_return(body: body)
      expected = DropletKit::SizeMapping.extract_collection(body, :read)

      expect(resource.all).to eq(expected)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) {'sizes/all'}
      let(:api_path) {'/v2/sizes'}
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/sizes' }
      let(:method) { :get }
      let(:action) { :all }
    end
  end
end
