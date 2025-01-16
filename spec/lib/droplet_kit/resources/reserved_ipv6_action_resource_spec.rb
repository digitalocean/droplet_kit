# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::ReservedIpv6ActionResource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  describe '#assign' do
    let(:ip) { 'fe80::1' }
    let(:droplet_id) { 123 }
    let(:path) { "/v2/reserved_ipv6/#{ip}/actions" }
    let(:action) { 'assign' }
    let(:fixture) { api_fixture("reserved_ipv6_actions/#{action}") }

    it 'sends an assign request for a reserved ipv6' do
      request = stub_do_api(path).with(
        body: { type: action, droplet_id: droplet_id }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.assign(ip: ip, droplet_id: droplet_id)

      expect(request).to have_been_made

      expect(action).to be_a(DropletKit::Action)
      expect(action.id).to eq(2)
      expect(action.status).to eq('in-progress')
      expect(action.type).to eq('assign_ip')
      expect(action.started_at).to eq('2014-08-05T15:15:28Z')
      expect(action.completed_at).to be_nil
      expect(action.resource_id).to eq(0)
      expect(action.resource_type).to eq('reserved_ipv6')
      expect(action.region_slug).to eq('nyc1')

      expect(action.region).to be_nil
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { ip: ip } }
    end

    it_behaves_like 'an action that handles bad request' do
      let(:arguments) { { ip: ip, droplet_id: droplet_id } }
    end
  end

  describe '#unassign' do
    let(:ip) { 'fe80::1' }
    let(:path) { "/v2/reserved_ipv6/#{ip}/actions" }
    let(:action) { 'unassign' }
    let(:fixture) { api_fixture("reserved_ipv6_actions/#{action}") }

    it 'sends an unassign request for a reserved ipv6' do
      request = stub_do_api(path).with(
        body: { type: action }.to_json
      ).to_return(body: fixture, status: 201)

      action = resource.unassign(ip: ip)

      expect(request).to have_been_made

      expect(action).to be_a(DropletKit::Action)
      expect(action.id).to eq(2)
      expect(action.status).to eq('in-progress')
      expect(action.type).to eq('unassign_ip')
      expect(action.started_at).to eq('2014-08-05T15:15:28Z')
      expect(action.completed_at).to be_nil
      expect(action.resource_id).to eq(0)
      expect(action.resource_type).to eq('reserved_ipv6')
      expect(action.region_slug).to eq('nyc1')

      expect(action.region).to be_nil
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:arguments) { { ip: ip } }
    end

    it_behaves_like 'an action that handles bad request' do
      let(:arguments) { { ip: ip } }
    end
  end
end
