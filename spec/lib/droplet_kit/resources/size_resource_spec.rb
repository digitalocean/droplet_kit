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
  end
end