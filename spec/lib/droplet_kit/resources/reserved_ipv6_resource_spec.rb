# frozen_string_literal: true

require 'spec_helper'
RSpec.describe DropletKit::ReservedIpv6Resource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  RSpec::Matchers.define :match_reserved_ipv6_fixture do |droplet|
    match do |reserved_ip|
      expect(reserved_ip.droplet).to be_a(DropletKit::Droplet) if droplet

      reserved_ip.ip == '2a03:b0c0:3:f0::5dcf:9000'
    end
  end

  describe '#all' do
    it 'returns all of the reserved_ipv6s' do
      stub_do_api('/v2/reserved_ipv6', :get).to_return(body: api_fixture('reserved_ipv6/all'))
      reserved_ips = resource.all
      expect(reserved_ips).to all(be_a(DropletKit::ReservedIpv6))

      expect(reserved_ips.first).to match_reserved_ipv6_fixture
    end

    it 'returns an empty array of reserved_ipv6s' do
      stub_do_api('/v2/reserved_ipv6', :get).to_return(body: api_fixture('reserved_ipv6/all_empty'))
      reserved_ips = resource.all.map(&:ip)
      expect(reserved_ips).to be_empty
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'reserved_ipv6/all' }
      let(:api_path) { '/v2/reserved_ipv6' }
    end
  end

  describe '#find' do
    it 'returns a singular reserved_ipv6' do
      stub_do_api('/v2/reserved_ipv6/2a03:b0c0:3:f0::5dcf:9000', :get).to_return(body: api_fixture('reserved_ipv6/find'))
      reserved_ip = resource.find(ip: '2a03:b0c0:3:f0::5dcf:9000')
      expect(reserved_ip).to be_a(DropletKit::ReservedIpv6)
      expect(reserved_ip).to match_reserved_ipv6_fixture
    end

    it 'return a not_found response' do
      stub_do_api('/v2/reserved_ipv6/2a03:b0c0:3:f0::5dcf:9000', :get).to_return(body: '{"id": "not_found", "message": "not found"}', status: 404)
      expect { resource.find(ip: '2a03:b0c0:3:f0::5dcf:9000') }.to raise_exception(DropletKit::Error).with_message('not found')
    end
  end

  describe '#create' do
    let(:path) { '/v2/reserved_ipv6' }

    context 'with a successful create' do
      it 'returns the created reserved_ipv6' do
        reserved_ip = DropletKit::ReservedIpv6.new(
          region_slug: 'nyc1'
        )

        as_string = DropletKit::ReservedIpv6Mapping.representation_for(:create, reserved_ip)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('reserved_ipv6/create'), status: 201)
        reserved_ip = resource.create(reserved_ip)
        expect(reserved_ip.ip).to eq('2604:a880:800:14::79d4:4000')
        expect(reserved_ip.region_slug).to eq('nyc1')
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::ReservedIpv6.new }
    end
  end

  describe '#delete' do
    it 'sends a delete request for the reserved_ipv6' do
      request = stub_do_api('/v2/reserved_ipv6/2a03:b0c0:3:f0::5dcf:9000', :delete)
      resource.delete(ip: '2a03:b0c0:3:f0::5dcf:9000')

      expect(request).to have_been_made
    end

    it 'return a not_found response' do
      stub_do_api('/v2/reserved_ipv6/2a03:b0c0:3:f0::5dcf:9000', :delete).to_return(body: '{"id": "not_found", "message": "not found"}', status: 404)
      expect { resource.delete(ip: '2a03:b0c0:3:f0::5dcf:9000') }.to raise_exception(DropletKit::FailedDelete).with_message('not found')
    end
  end
end
