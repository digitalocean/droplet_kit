require 'spec_helper'

RSpec.describe DropletKit::RegionResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns a collection of regions' do
      body = api_fixture('regions/all')
      stub_do_api('/v2/regions').to_return(body: body)
      expected = DropletKit::RegionMapping.extract_collection(body, :read)

      expect(resource.all).to eq(expected)
    end
  end
end