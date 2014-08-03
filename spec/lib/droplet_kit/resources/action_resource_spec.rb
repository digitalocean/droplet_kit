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

  describe '#find' do
    it 'returns an action' do
      response = api_fixture('actions/find')
      stub_do_api('/v2/actions/123', :get).to_return(body: response)
      expected_action = DropletKit::ActionMapping.extract_single(response, :read)

      expect(resource.find(id: 123)).to eq(expected_action)
    end
  end
end