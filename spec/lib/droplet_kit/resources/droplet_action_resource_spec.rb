require 'spec_helper'

RSpec.describe DropletKit::DropletActionResource do
  subject(:resource) { described_class.new(connection: connection) }
  let(:droplet_id) { 1066 }

  let(:fixture) { api_fixture("droplet_actions/#{action}") }

  include_context 'resources'

  describe '#action_for_id' do
    let(:action) { 'event' }
    let(:path) { "/v2/droplets/#{droplet_id}/actions" }
    let(:fixture) { api_fixture('droplet_actions/find') }

    it 'performs the action' do
      request = stub_do_api(path, :post).with(
        body: { type: action, param_1: 1, param_2: 2 }.to_json
      ).to_return(body: fixture, status: 201)

      resource.action_for_id(droplet_id: droplet_id, type: action, param_1: 1, param_2: 2)
      expect(request).to have_been_made
    end
  end

  describe '#action_for_tag' do
    let(:action) { 'event' }
    let(:path) { '/v2/droplets/actions' }
    let(:fixture) { api_fixture('droplet_actions/find') }

    it 'performs the action' do
      request = stub_do_api(path, :post).with(
        body: { tag_name: 'test-tag', type: action, param_1: 1, param_2: 2 }.to_json
      ).to_return(body: fixture, status: 201)

      resource.action_for_tag(tag_name: 'test-tag', type: action, param_1: 1, param_2: 2)
      expect(request).to have_been_made
    end
  end

  described_class::ACTIONS_WITHOUT_INPUT.each do |action_name|
    describe "Action #{action_name}" do
      let(:action) { action_name }
      let(:path) { "/v2/droplets/#{droplet_id}/actions" }

      it 'performs the action' do
        request = stub_do_api(path, :post).with(
          body: { type: action }.to_json
        ).to_return(body: fixture, status: 201)

        returned_action = resource.send(action, droplet_id: droplet_id)

        expect(request).to have_been_made
        expect(returned_action.type).to eq(action)
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:object) { DropletKit::Droplet.new }
        let(:arguments) { { droplet_id: droplet_id } }
      end
    end
  end

  described_class::TAG_ACTIONS.each do |action_name|
    describe "Batch Action #{action_name}" do
      let(:action) { "#{action_name}_for_tag" }
      let(:path) { "/v2/droplets/actions?tag_name=testing-1" }
      let(:fixture) do
        single_action = DropletKit::ActionMapping.extract_single(api_fixture("droplet_actions/#{action_name}"), :read)

        DropletKit::ActionMapping.represent_collection_for(:read, [single_action])
      end

      it 'performs the action' do
        request = stub_do_api(path, :post).with(
          body: { type: action_name }.to_json
        ).to_return(body: fixture, status: 201)

        returned_actions = resource.send(action, tag_name: 'testing-1')

        expect(request).to have_been_made
        expect(returned_actions.first.type).to eq(action_name)
      end
    end
  end

  describe "Action snapshot" do
    let(:action) { 'snapshot' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, name: 'Dwight' }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, name: 'Dwight')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action change_kernel" do
    let(:action) { 'change_kernel' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, kernel: 1556 }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, kernel: 1556)

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action rename" do
    let(:action) { 'rename' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, name: 'newname.com' }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, name: 'newname.com')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action rebuild" do
    let(:action) { 'rebuild' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, image: 'ubuntu-14-04-x86' }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, image: 'ubuntu-14-04-x86')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action restore" do
    let(:action) { 'restore' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, image: 'ubuntu-14-04-x86' }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, image: 'ubuntu-14-04-x86')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action resize" do
    let(:action) { 'resize' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, size: '1gb', disk: nil }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, size: '1gb')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action resize with disk" do
    let(:action) { 'resize' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, size: '1gb', disk: true }.to_json
      ).to_return(body: fixture, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, size: '1gb', disk: true)

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe '#find' do
    it 'returns an action' do
      request = stub_do_api("/v2/droplets/1066/actions/123", :get).to_return(
        body: api_fixture('droplet_actions/find')
      )

      returned_action = resource.find(droplet_id: 1066, id: 123)
      expect(request).to have_been_made

      expect(returned_action.type).to eq('test')
      expect(returned_action.started_at).to eq("2014-07-29T14:35:27Z")
      expect(returned_action.completed_at).to eq(nil)
      expect(returned_action.resource_id).to eq(nil)
      expect(returned_action.resource_type).to eq("backend")
      expect(returned_action.region_slug).to eq('nyc1')

      expect(returned_action.region).to be_kind_of(DropletKit::Region)
      expect(returned_action.region.slug).to eq('nyc1')
      expect(returned_action.region.name).to eq('New York')
      expect(returned_action.region.sizes).to include('512mb')
      expect(returned_action.region.available).to be(true)
      expect(returned_action.region.features).to include("virtio", "private_networking", "backups", "ipv6", "metadata")
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/droplets/1066/actions/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { droplet_id: 1066, id: 123 } }
    end
  end
end
