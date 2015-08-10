require 'spec_helper'

RSpec.describe DropletKit::ActionResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all actions' do
      response = api_fixture('actions/all')
      stub_do_api('/v2/actions', :get).to_return(body: response)
      expected_actions = DropletKit::ActionMapping.extract_collection(response, :read)

      expect(resource.all).to eq(expected_actions)
    end

    it 'returns a list of correctly mapped actions' do
      response = api_fixture('actions/all')
      stub_do_api('/v2/actions', :get).to_return(body: response)
      actions = resource.all

      expect(actions.first).to be_kind_of(DropletKit::Action)
      expect(actions.first.id).to eq(1)
      expect(actions.first.status).to eq("in-progress")
      expect(actions.first.type).to eq("test")
      expect(actions.first.started_at).to eq("2014-07-29T14:35:26Z")
      expect(actions.first.completed_at).to eq(nil)
      expect(actions.first.resource_id).to eq(nil)
      expect(actions.first.resource_type).to eq("backend")

      expect(actions.first.region).to be_kind_of(DropletKit::Region)
      expect(actions.first.region.slug).to eq('nyc1')
      expect(actions.first.region.name).to eq('New York')
      expect(actions.first.region.sizes).to include('512mb')
      expect(actions.first.region.available).to be(true)
      expect(actions.first.region.features).to include("virtio", "private_networking", "backups", "ipv6", "metadata")
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'actions/all' }
      let(:api_path) { '/v2/actions' }
    end
  end

  describe '#find' do
    it 'returns an action' do
      response = api_fixture('actions/find')
      stub_do_api('/v2/actions/123', :get).to_return(body: response)
      expected_action = DropletKit::ActionMapping.extract_single(response, :read)

      expect(resource.find(id: 123)).to eq(expected_action)
    end

    it 'returns a correctly mapped action' do
      response = api_fixture('actions/find')
      stub_do_api('/v2/actions/123', :get).to_return(body: response)
      action = resource.find(id: 123)

      expect(action).to be_kind_of(DropletKit::Action)
      expect(action.id).to eq(2)
      expect(action.status).to eq("in-progress")
      expect(action.type).to eq("test")
      expect(action.started_at).to eq("2014-07-29T14:35:27Z")
      expect(action.completed_at).to eq(nil)
      expect(action.resource_id).to eq(nil)
      expect(action.resource_type).to eq("backend")
      expect(action.region_slug).to eq("nyc1")

      expect(action.region).to be_kind_of(DropletKit::Region)
      expect(action.region.slug).to eq('nyc1')
      expect(action.region.name).to eq('New York')
      expect(action.region.sizes).to include('512mb')
      expect(action.region.available).to be(true)
      expect(action.region.features).to include("virtio", "private_networking", "backups", "ipv6", "metadata")
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/actions/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { id: 123 } }
    end
  end
end
