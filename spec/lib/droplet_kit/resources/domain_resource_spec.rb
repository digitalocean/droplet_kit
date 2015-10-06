require 'spec_helper'

RSpec.describe DropletKit::DomainResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all of the domains' do
      response = api_fixture('domains/all')
      stub_do_api('/v2/domains', :get).to_return(body: response)
      expected_domains = DropletKit::DomainMapping.extract_collection(response, :read)

      expect(resource.all).to eq(expected_domains)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) {'domains/all'}
      let(:api_path) {'/v2/domains'}
    end
  end

  describe '#create' do
    it 'send a POST request to create a domain' do
      response = api_fixture('domains/create')

      domain = DropletKit::Domain.new(ip_address: '1.1.1.1', name: 'example.com')
      as_hash = DropletKit::DomainMapping.hash_for(:create, domain)
      expect(as_hash['ip_address']).to eq('1.1.1.1')
      expect(as_hash['name']).to eq('example.com')

      as_json = DropletKit::DomainMapping.representation_for(:create, domain)
      stub_do_api('/v2/domains', :post).with(body: as_json).to_return(body: response, status: 201)

      created_domain = resource.create(domain)
      expect(created_domain.name).to eq('example.com')
      expect(created_domain.ttl).to eq(1800)
      expect(created_domain.zone_file).to eq(nil)
    end
  end

  describe '#find' do
    it 'returns a single domain' do
      response = api_fixture('domains/find')
      stub_do_api('/v2/domains/example.com', :get).to_return(body: response)
      expected_domain = DropletKit::DomainMapping.extract_single(response, :read)

      expect(resource.find(name: 'example.com')).to eq(expected_domain)
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/domains/example.com' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { name: 'example.com' } }
    end
  end

  describe '#delete' do
    it 'deletes a single domain' do
      request = stub_do_api('/v2/domains/example.com', :delete)
      resource.delete(name: 'example.com')
      expect(request).to have_been_made
    end
  end
end
