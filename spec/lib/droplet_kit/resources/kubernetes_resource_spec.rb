require 'spec_helper'

RSpec.describe DropletKit::KubernetesResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all of the clusters' do
      stub_do_api('/v2/kubernetes/clusters', :get).to_return(body: api_fixture('kubernetes/all'))
      clusters = resource.all
      expect(clusters).to all(be_kind_of(DropletKit::Kubernetes))

      cluster = clusters.first
      expect(cluster.id).to eq("cluster-1-id")
    end

    it 'returns an empty array of droplets' do
      stub_do_api('/v2/kubernetes/clusters', :get).to_return(body: api_fixture('kubernetes/all_empty'))
      clusters = resource.all.map(&:id)
      expect(clusters).to be_empty
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'kubernetes/all' }
      let(:api_path) { '/v2/kubernetes/clusters' }
    end
  end
end
