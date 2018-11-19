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

  describe '#all' do
    it 'returns all of the clusters' do
      stub_do_api('/v2/kubernetes/clusters', :get).to_return(body: api_fixture('kubernetes/all'))
      clusters = resource.all
      expect(clusters).to all(be_kind_of(DropletKit::Kubernetes))

      cluster = clusters.first

      expect(cluster.id).to eq("cluster-1-id")
      expect(cluster.name).to eq("test-cluster")
      expect(cluster.region).to eq("nyc1")
      expect(cluster.version).to eq("1.12.1-do.2")
      expect(cluster.cluster_subnet).to eq("10.244.0.0/16")
      expect(cluster.ipv4).to eq("0.0.0.0")
      expect(cluster.tags).to match_array(["test-k8", "k8s", "k8s:cluster-1-id"])
      expect(cluster.node_pools.count).to eq(1)
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

  describe '#create' do
    let(:path) { '/v2/kubernetes/clusters' }
    let(:new_attrs) do
      {
        "name": "test-cluster-01",
        "region": "nyc1",
        "version": "1.12.1-do.2",
        "tags": ["test"],
        "node_pools": [
          {
            "size": "s-1vcpu-1gb",
            "count": 3,
            "name": "frontend-pool",
            "tags": ["frontend"]
          },
          {
            "size": "c-4",
            "count": 2,
            "name": "backend-pool"
          }
        ]
      }
    end

    context 'for a successful create' do
      it 'returns the created cluster' do
        cluster = DropletKit::Kubernetes.new(new_attrs)

        as_hash = DropletKit::KubernetesMapping.hash_for(:create, cluster)
        expect(as_hash['name']).to eq(cluster.name)
        expect(as_hash['region']).to eq(cluster.region)
        expect(as_hash['version']).to eq(cluster.version)
        expect(as_hash['tags']).to eq(cluster.tags)
        expect(as_hash['node_pools']).to eq(cluster.node_pools)


        as_string = DropletKit::KubernetesMapping.representation_for(:create, cluster)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('kubernetes/create'), status: 201)
        created_cluster = resource.create(cluster)
        expect(cluster.id).to eq("cluster-1-id")
        expect(cluster.name).to eq("test-cluster")
        expect(cluster.region).to eq("nyc1")
        expect(cluster.version).to eq("1.12.1-do.2")
        expect(cluster.cluster_subnet).to eq("10.244.0.0/16")
        expect(cluster.ipv4).to eq("0.0.0.0")
        expect(cluster.tags).to match_array(["test-k8", "k8s", "k8s:cluster-1-id"])
        expect(cluster.node_pools.count).to eq(1)
      end

      it 'reuses the same object' do
        cluster = DropletKit::Kubernetes.new(new_attrs)

        json = DropletKit::KubernetesMapping.representation_for(:create, cluster)
        stub_do_api(path, :post).with(body: json).to_return(body: api_fixture('kubernetes/create'), status: 201)
        created_cluster = resource.create(cluster)
        expect(created_cluster).to be cluster
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::Kubernetes.new }
    end
  end
end
