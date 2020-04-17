require 'spec_helper'

RSpec.describe DropletKit::ContainerRegistryRepositoryResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns a list of repositories' do
      response = api_fixture('container_registry/list-repos')
      stub_do_api('/v2/registry/my-registry/repositories', :get).to_return(body: response)

      expected_repos = DropletKit::ContainerRegistryRepositoryMapping.extract_collection(response, :read)
      returned_repos = resource.all(registry_name: 'my-registry')

      expect(returned_repos).to all(be_kind_of(DropletKit::ContainerRegistryRepository))
      expect(returned_repos).to eq(expected_repos)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) {'container_registry/list-repos'}
      let(:api_path) {'/v2/registry/my-registry/repositories'}
    end
  end

  describe '#tags' do
    it 'returns a list of tags' do
      response = api_fixture('container_registry/list-repo-tags')
      stub_do_api('/v2/registry/my-registry/repositories/my-repo/tags', :get).to_return(body: response)

      expected_tags = DropletKit::ContainerRegistryRepositoryTagMapping.extract_collection(response, :read)
      returned_tags = resource.tags(registry_name: 'my-registry', repository: 'my-repo')

      expect(returned_tags).to all(be_kind_of(DropletKit::ContainerRegistryRepositoryTag))
      expect(returned_tags).to eq(expected_tags)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) {'container_registry/list-repo-tags'}
      let(:api_path) {'/v2/registry/my-registry/repositories/my-repo/tags'}
    end
  end

  describe '#delete_tag' do
    it 'sends a delete request for a repository tag' do
      request = stub_do_api('/v2/registry/my-registry/repositories/my-repo/tags/my-tag', :delete).to_return(status: 204)
      response = resource.delete_tag(registry_name: 'my-registry', repository: 'my-repo', tag: 'my-tag')

      expect(request).to have_been_made
      expect(response).to eq(true)
    end
  end

  describe '#delete_manifest' do
    it 'sends a delete request for a repository manifest' do
      request = stub_do_api('/v2/registry/my-registry/repositories/my-repo/digests/sha256:cb8a924afdf0229ef7515d9e5b3024e23b3eb03ddbba287f4a19c6ac90b8d221', :delete).to_return(status: 204)
      response = resource.delete_manifest(registry_name: 'my-registry', repository: 'my-repo', manifest_digest: 'sha256:cb8a924afdf0229ef7515d9e5b3024e23b3eb03ddbba287f4a19c6ac90b8d221')

      expect(request).to have_been_made
      expect(response).to eq(true)
    end
  end
end
