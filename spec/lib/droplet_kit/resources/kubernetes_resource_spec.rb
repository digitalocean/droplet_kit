require 'spec_helper'

RSpec.describe DropletKit::KubernetesResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#find' do
    it 'returns a singular cluster' do
      stub_do_api('/v2/kubernetes/clusters/20', :get).to_return(body: api_fixture('kubernetes/clusters/find'))
      cluster = resource.find(id: 20)
      expect(cluster).to be_kind_of(DropletKit::Kubernetes)

      expect(cluster.id).to eq("cluster-1-id")
      expect(cluster.name).to eq("test-cluster")
      expect(cluster.region).to eq("nyc1")
      expect(cluster.version).to eq("1.12.1-do.2")
      expect(cluster.cluster_subnet).to eq("10.244.0.0/16")
      expect(cluster.ipv4).to eq("0.0.0.0")
      expect(cluster.tags).to match_array(["test-k8", "k8s", "k8s:cluster-1-id"])
      expect(cluster.node_pools.count).to eq(1)
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/kubernetes/clusters/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { id: 123 } }
    end
  end

  describe '#update' do
    let(:path) { '/v2/kubernetes/clusters' }
    let(:new_attrs) do
      {
        "name" => "new-test-name",
        "tags" => ["new-test"]
      }
    end

    context 'for a successful update' do
      it 'returns the created cluster' do
        cluster = DropletKit::Kubernetes.new(new_attrs)

        as_hash = DropletKit::KubernetesMapping.hash_for(:update, cluster)
        expect(as_hash['name']).to eq(cluster.name)
        expect(as_hash['tags']).to eq(cluster.tags)


        as_string = DropletKit::KubernetesMapping.representation_for(:update, cluster)
        stub_do_api(path, :put).with(body: as_string).to_return(body: api_fixture('kubernetes/clusters/update'), status: 202)

        updated_cluster = resource.update(cluster)
        expect(updated_cluster.name).to eq("new-test-name")
        expect(updated_cluster.tags).to match_array(["new-test"])
      end
    end
  end
end
