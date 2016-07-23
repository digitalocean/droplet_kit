require 'spec_helper'

RSpec.describe DropletKit::VolumeActionResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_volume_action_fixture do |type|
    match do |action|
      expect(action).to be_kind_of(DropletKit::Action)
      expect(action.id).to eq(72531856)
      expect(action.status).to eq("in-progress")
      expect(action.type).to eq(type) if type
      expect(action.started_at).to eq("2015-11-12T17:51:03Z")
      expect(action.completed_at).to eq(nil)
      expect(action.resource_id).to eq(nil)
      expect(action.resource_type).to eq("volume")
      expect(action.region_slug).to eq("nyc1")

      expect(action.region).to be_kind_of(DropletKit::Region)
    end
  end

  describe '#attach' do
    let(:volume_id) { '7724db7c-e098-11e5-b522-000f53304e51' }
    let(:droplet_id) { 123 }
    let(:region) { 'nyc1' }
    let(:path) { "/v2/volumes/#{volume_id}/actions" }
    let(:action) { 'attach' }
    let(:fixture) { api_fixture("volume_actions/#{action}") }

    it 'sends an attach request for a volume' do
      request = stub_do_api(path).with(
        body: {
          type: action,
          droplet_id: droplet_id,
          volume_id: volume_id,
          region: region
        }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.attach(
        volume_id: volume_id,
        droplet_id: droplet_id,
        region: region
      )

      expect(request).to have_been_made
      expect(action).to match_volume_action_fixture('attach_volume')
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { volume_id: volume_id, droplet_id: droplet_id } }
    end
  end

  describe '#detach' do
    let(:volume_id) { '7724db7c-e098-11e5-b522-000f53304e51' }
    let(:droplet_id) { 123 }
    let(:region) { 'nyc1' }
    let(:path) { "/v2/volumes/#{volume_id}/actions" }
    let(:action) { 'detach' }
    let(:fixture) { api_fixture("volume_actions/#{action}") }

    it 'sends an detach request for a volume' do
      request = stub_do_api(path).with(
        body: {
          type: action,
          droplet_id: droplet_id,
          volume_id: volume_id,
          region: region
        }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.detach(
        volume_id: volume_id,
        droplet_id: droplet_id,
        region: region
      )

      expect(request).to have_been_made
      expect(action).to match_volume_action_fixture('detach_volume')
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { volume_id: volume_id } }
    end
  end

  describe '#resize' do
    let(:volume_id) { '7724db7c-e098-11e5-b522-000f53304e51' }
    let(:region) { 'nyc1' }
    let(:path) { "/v2/volumes/#{volume_id}/actions" }
    let(:action) { 'resize' }
    let(:fixture) { api_fixture("volume_actions/#{action}") }

    it 'sends an resize request for a volume' do
      request = stub_do_api(path).with(
        body: {
          type: action,
          size_gigabytes: 100,
          region: region
        }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.resize(
        volume_id: volume_id,
        region: region,
        size_gigabytes: 100
      )

      expect(request).to have_been_made
      expect(action).to match_volume_action_fixture('resize_volume')
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { volume_id: volume_id } }
    end
  end

  describe '#all' do
    let(:volume_id) { '7724db7c-e098-11e5-b522-000f53304e51' }

    it 'returns all of the volume actions via a paginated resources' do
      request = stub_do_api("/v2/volumes/#{volume_id}/actions", :get).to_return(
        body: api_fixture('volume_actions/all'),
        status: 200
      )

      actions = resource.all(volume_id: volume_id).take(20)

      expect(request).to have_been_made

      expect(actions.size).to be(1)

      action = actions.first
      expect(action).to match_volume_action_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'volume_actions/all' }
      let(:api_path) { "/v2/volumes/#{volume_id}/actions" }
      let(:parameters) { { volume_id: volume_id } }
    end
  end

  describe '#find' do
    let(:id) { 72531856 }
    let(:volume_id) { '7724db7c-e098-11e5-b522-000f53304e51' }

    it 'returns a single action' do
      stub_do_api("/v2/volumes/#{volume_id}/actions/#{id}", :get).to_return(body: api_fixture('volume_actions/find'))
      action = resource.find(id: id, volume_id: volume_id)

      expect(action).to match_volume_action_fixture
    end
  end
end