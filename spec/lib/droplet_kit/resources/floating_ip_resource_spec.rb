require 'spec_helper'

RSpec.describe DropletKit::FloatingIpResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_floating_ip_fixture do |droplet|
    match do |floating_ip|
      expect(floating_ip.region).to be_kind_of(DropletKit::Region)
      expect(floating_ip.droplet).to be_kind_of(DropletKit::Droplet) if droplet

      floating_ip.ip == "45.55.96.32"
    end
  end

  describe '#all' do
    it 'returns all of the floating_ips' do
      stub_do_api('/v2/floating_ips', :get).to_return(body: api_fixture('floating_ips/all'))
      floating_ips = resource.all
      expect(floating_ips).to all(be_kind_of(DropletKit::FloatingIp))

      expect(floating_ips.first).to match_floating_ip_fixture
    end

    it 'returns an empty array of floating_ips' do
      stub_do_api('/v2/floating_ips', :get).to_return(body: api_fixture('floating_ips/all_empty'))
      floating_ips = resource.all.map(&:ip)
      expect(floating_ips).to be_empty
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'floating_ips/all' }
      let(:api_path) { '/v2/floating_ips' }
    end
  end

  describe '#find' do
    it 'returns a singular floating_ip' do
      stub_do_api('/v2/floating_ips/45.55.96.32', :get).to_return(body: api_fixture('floating_ips/find'))
      floating_ip = resource.find(ip: "45.55.96.32")
      expect(floating_ip).to be_kind_of(DropletKit::FloatingIp)
      expect(floating_ip).to match_floating_ip_fixture
    end
  end

  describe '#create' do
    let(:path) { '/v2/floating_ips' }

    context 'for a successful create' do
      it 'returns the created floating_ip' do
        floating_ip = DropletKit::FloatingIp.new(
          region: 'nyc1'
        )

        as_string = DropletKit::FloatingIpMapping.representation_for(:create, floating_ip)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('floating_ips/create'), status: 202)
        created_floating_ip = resource.create(floating_ip)

        expect(created_floating_ip).to match_floating_ip_fixture
      end
    end

    context 'for a successful create with droplet' do
      it 'returns the created floating_ip' do
        floating_ip = DropletKit::FloatingIp.new(
          droplet_id: 123
        )

        as_string = DropletKit::FloatingIpMapping.representation_for(:create, floating_ip)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('floating_ips/create_with_droplet'), status: 202)
        created_floating_ip = resource.create(floating_ip)

        expect(created_floating_ip).to match_floating_ip_fixture
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::FloatingIp.new }
    end
  end

  describe '#delete' do
    it 'sends a delete request for the floating_ip' do
      request = stub_do_api('/v2/floating_ips/45.55.96.32', :delete)
      resource.delete(ip: "45.55.96.32")

      expect(request).to have_been_made
    end
  end
end