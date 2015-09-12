require 'spec_helper'

RSpec.describe DropletKit::FloatingIpActionResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#assign' do
    let(:ip) { '127.0.0.1' }
    let(:droplet_id) { 123 }
    let(:path) { "/v2/floating_ips/#{ip}/actions" }
    let(:action) { 'assign' }
    let(:fixture) { api_fixture("floating_ip_actions/#{action}") }

    it 'sends an assign request for a floating ip' do
      request = stub_do_api(path).with(
        body: { type: action, droplet_id: droplet_id }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.assign(ip: ip, droplet_id: droplet_id)

      expect(request).to have_been_made

      expect(action).to be_kind_of(DropletKit::Action)
      expect(action.id).to eq(2)
      expect(action.status).to eq("in-progress")
      expect(action.type).to eq("assign")
      expect(action.started_at).to eq("2014-08-05T15:15:28Z")
      expect(action.completed_at).to eq(nil)
      expect(action.resource_id).to eq(12)
      expect(action.resource_type).to eq("floating_ip")
      expect(action.region_slug).to eq("nyc1")

      expect(action.region).to be_kind_of(DropletKit::Region)
      expect(action.region.slug).to eq('nyc1')
      expect(action.region.name).to eq('New York')
      expect(action.region.sizes).to include('512mb')
      expect(action.region.available).to be(true)
      expect(action.region.features).to include("virtio", "private_networking", "backups", "ipv6", "metadata")
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { ip: ip, droplet_id: droplet_id } }
    end
  end

  describe '#unassign' do
    let(:ip) { '127.0.0.1' }
    let(:path) { "/v2/floating_ips/#{ip}/actions" }
    let(:action) { 'unassign' }
    let(:fixture) { api_fixture("floating_ip_actions/#{action}") }

    it 'sends an unassign request for a floating ip' do
      request = stub_do_api(path).with(
        body: { type: action }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.unassign(ip: ip)

      expect(request).to have_been_made

      expect(action).to be_kind_of(DropletKit::Action)
      expect(action.id).to eq(2)
      expect(action.status).to eq("in-progress")
      expect(action.type).to eq("unassign")
      expect(action.started_at).to eq("2014-08-05T15:15:28Z")
      expect(action.completed_at).to eq(nil)
      expect(action.resource_id).to eq(12)
      expect(action.resource_type).to eq("floating_ip")
      expect(action.region_slug).to eq("nyc1")

      expect(action.region).to be_kind_of(DropletKit::Region)
      expect(action.region.slug).to eq('nyc1')
      expect(action.region.name).to eq('New York')
      expect(action.region.sizes).to include('512mb')
      expect(action.region.available).to be(true)
      expect(action.region.features).to include("virtio", "private_networking", "backups", "ipv6", "metadata")
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { ip: ip } }
    end
  end

  describe '#all' do
    let(:ip) { '127.0.0.1' }

    it 'returns all of the floating ip actions via a paginated resources' do
      request = stub_do_api("/v2/floating_ips/#{ip}/actions", :get).to_return(
        body: api_fixture('floating_ip_actions/all'),
        status: 200
      )

      actions = resource.all(ip: ip).take(20)

      expect(request).to have_been_made

      expect(actions.size).to be(2)

      action = actions.first

      expect(action.id).to eq(19)
      expect(action.status).to eq("completed")
      expect(action.type).to eq("assign_ip")
      expect(action.started_at).to eq("2014-10-28T17:11:05Z")
      expect(action.completed_at).to eq("2014-10-28T17:11:06Z")
      expect(action.resource_id).to eq(45646587)
      expect(action.resource_type).to eq("floating_ip")
      expect(action.region).to be_kind_of(DropletKit::Region)
      expect(action.region_slug).to eq("nyc1")
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'floating_ip_actions/all' }
      let(:api_path) { "/v2/floating_ips/#{ip}/actions" }
      let(:parameters) { { ip: ip } }
    end
  end

  describe '#find' do
    let(:ip) { '127.0.0.1' }

    it 'returns a single action' do
      stub_do_api("/v2/floating_ips/#{ip}/actions/23", :get).to_return(body: api_fixture('floating_ip_actions/find'))
      action = resource.find(ip: ip, id: 23)

      expect(action.id).to eq(19)
      expect(action.status).to eq("completed")
      expect(action.type).to eq("assign_ip")
      expect(action.started_at).to eq("2014-10-28T17:11:05Z")
      expect(action.completed_at).to eq("2014-10-28T17:11:06Z")
      expect(action.resource_id).to eq(45646587)
      expect(action.resource_type).to eq("floating_ip")
      expect(action.region).to be_kind_of(DropletKit::Region)
      expect(action.region_slug).to eq("nyc1")
    end
  end
end