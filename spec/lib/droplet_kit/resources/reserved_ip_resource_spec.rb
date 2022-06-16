# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::ReservedIpResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_reserved_ip_fixture do |droplet|
    match do |reserved_ip|
      expect(reserved_ip.region).to be_kind_of(DropletKit::Region)
      expect(reserved_ip.droplet).to be_kind_of(DropletKit::Droplet) if droplet

      reserved_ip.ip == "45.55.96.32"
    end
  end

  describe '#all' do
    it 'returns all of the reserved_ips' do
      stub_do_api('/v2/reserved_ips', :get).to_return(body: api_fixture('reserved_ips/all'))
      reserved_ips = resource.all
      expect(reserved_ips).to all(be_kind_of(DropletKit::ReservedIp))

      expect(reserved_ips.first).to match_reserved_ip_fixture
    end

    it 'returns an empty array of reserved_ips' do
      stub_do_api('/v2/reserved_ips', :get).to_return(body: api_fixture('reserved_ips/all_empty'))
      reserved_ips = resource.all.map(&:ip)
      expect(reserved_ips).to be_empty
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'reserved_ips/all' }
      let(:api_path) { '/v2/reserved_ips' }
    end
  end

  describe '#find' do
    it 'returns a singular reserved_ip' do
      stub_do_api('/v2/reserved_ips/45.55.96.32', :get).to_return(body: api_fixture('reserved_ips/find'))
      reserved_ip = resource.find(ip: "45.55.96.32")
      expect(reserved_ip).to be_kind_of(DropletKit::ReservedIp)
      expect(reserved_ip).to match_reserved_ip_fixture
    end
  end

  describe '#create' do
    let(:path) { '/v2/reserved_ips' }

    context 'for a successful create' do
      it 'returns the created reserved_ip' do
        reserved_ip = DropletKit::ReservedIp.new(
          region: 'nyc1'
        )

        as_string = DropletKit::ReservedIpMapping.representation_for(:create, reserved_ip)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('reserved_ips/create'), status: 202)
        created_reserved_ip = resource.create(reserved_ip)

        expect(created_reserved_ip).to match_reserved_ip_fixture
      end
    end

    context 'for a successful create with droplet' do
      it 'returns the created reserved_ip' do
        reserved_ip = DropletKit::ReservedIp.new(
          droplet_id: 123
        )

        as_string = DropletKit::ReservedIpMapping.representation_for(:create, reserved_ip)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('reserved_ips/create_with_droplet'), status: 202)
        created_reserved_ip = resource.create(reserved_ip)

        expect(created_reserved_ip).to match_reserved_ip_fixture
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::ReservedIp.new }
    end
  end

  describe '#delete' do
    it 'sends a delete request for the reserved_ip' do
      request = stub_do_api('/v2/reserved_ips/45.55.96.32', :delete)
      resource.delete(ip: "45.55.96.32")

      expect(request).to have_been_made
    end
  end
end