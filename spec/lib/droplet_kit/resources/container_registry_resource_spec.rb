# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::ContainerRegistryResource do # rubocop:todo RSpec/SpecFilePathFormat
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  describe '#get' do
    it 'returns a registry' do
      stub_do_api('/v2/registry', :get).to_return(body: api_fixture('container_registry/get'))
      registry = resource.get
      expect(registry).to be_a(DropletKit::ContainerRegistry)

      expect(registry.name).to eq('foobar')
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/registry' }
      let(:method) { :get }
      let(:action) { :get }
    end
  end

  describe '#create' do
    let(:path) { '/v2/registry' }
    let(:new_attrs) do
      {
        'name' => 'foobar'
      }
    end

    context 'for a successful create' do
      it 'returns the created registry' do
        registry = DropletKit::ContainerRegistry.new(new_attrs)

        as_hash = DropletKit::ContainerRegistryMapping.hash_for(:create, registry)
        expect(as_hash['name']).to eq(registry.name)

        as_string = DropletKit::ContainerRegistryMapping.representation_for(:create, registry)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('container_registry/create'), status: 201)
        resource.create(registry)
        expect(registry.name).to eq('foobar')
      end

      it 'reuses the same object' do
        registry = DropletKit::ContainerRegistry.new(new_attrs)

        json = DropletKit::ContainerRegistryMapping.representation_for(:create, registry)
        stub_do_api(path, :post).with(body: json).to_return(body: api_fixture('container_registry/create'), status: 201)
        created_registry = resource.create(registry)
        expect(created_registry).to be registry
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::ContainerRegistry.new }
    end
  end

  describe '#delete' do
    it 'sends a delete request for a registry' do
      request = stub_do_api('/v2/registry', :delete).to_return(status: 204)
      response = resource.delete

      expect(request).to have_been_made
      expect(response).to be(true)
    end
  end

  describe '#docker-credentials' do
    it 'returns docker credentials' do
      response = Pathname.new('./spec/fixtures/container_registry/docker-credentials.json').read
      stub_do_api('/v2/registry/docker-credentials', :get).to_return(body: response)
      creds = resource.docker_credentials

      expect(creds).to be_a(String)
      parsed_creds = JSON.parse(creds)
      expect(parsed_creds).to eq(
        'auths' => {
          'registry.digitalocean.com' => {
            'auth' => 'secret'
          }
        }
      )
    end
  end
end
