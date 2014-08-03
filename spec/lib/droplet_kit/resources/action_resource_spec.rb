require 'spec_helper'

RSpec.describe DropletKit::ActionResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all actions' do
      response = api_fixture('actions/all')
      stub_do_api('/v2/actions', :get).to_return(body: response)
      expected_actions = DropletKit::ActionMapping.extract_collection(response, :read)

      expect(resource.all).to eq(expected_actions)
    end
  end
end