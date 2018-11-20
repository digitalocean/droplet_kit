require 'spec_helper'
require 'pry'

RSpec.describe DropletKit::KubernetesResource do
  subject(:resource) { described_class.new(connection: connection) }
  let(:kubernetes_node_pool_attributes) { DropletKit::KubernetesNodePool.new.attributes }
  include_context 'resources'
  let(:cluster_id) { "c28bf806-eba8-4a6d-a98f-8fd388740bd0" }

  describe "cluster_node_pools" do
    it 'returns the node_pools for a cluster' do
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools", :get).to_return(body: api_fixture('kubernetes/cluster_node_pools'))
      node_pools= resource.cluster_node_pools(id: cluster_id)
      node_pools.each do |pool|
        expect(pool).to be_kind_of(DropletKit::KubernetesNodePool)
        expect(pool.attributes.keys).to eq kubernetes_node_pool_attributes.keys
      end
      expect(node_pools.length).to eq 1
      expect(node_pools.first["id"]).to eq "0a209365-2fac-465e-a959-bb91f232923a"
      expect(node_pools.first["name"]).to eq "k8s-1-12-1-do-1-nyc1-1540837045848-1"
      expect(node_pools.first["size"]).to eq "s-4vcpu-8gb"
      expect(node_pools.first["count"]).to eq 2
      expect(node_pools.first["tags"]).to eq [ "omar-left-his-mark" ]
      expect(node_pools.first["nodes"].length).to eq 2
    end
  end

  describe "cluster_find_node_pool" do
    it "should return a single node pool" do
      node_pool_id = "f9f16e5a-83b8-4c9b-acf1-4f91492a6652"
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools/#{node_pool_id}", :get).to_return(body: api_fixture('kubernetes/cluster_node_pool'))
      node_pool = resource.cluster_find_node_pool(id: cluster_id, pool_id: node_pool_id)

      expect(node_pool.id).to eq node_pool_id
      expect(node_pool.name).to eq "k8s-1-12-1-do-2-nyc1-1542638764614-1"
      expect(node_pool.size).to eq "s-1vcpu-1gb"
      expect(node_pool.count).to eq 1
      expect(node_pool.tags).to eq ["k8s", "k8s:c28bf806-eba8-4a6d-a98f-8fd388740bd0", "k8s:worker"]
      expect(node_pool.nodes.length).to eq 1
      expect(node_pool.nodes.first.name).to eq "blissful-antonelli-3u87"
      expect(node_pool.nodes.first.status['state']).to eq "running"
    end
  end

  describe "cluster_node_pool_create" do
    it 'should create a node_pool in a cluster' do
      node_pool = DropletKit::KubernetesNodePool.new(
        name: 'frontend',
        size: 's-1vcpu-1gb',
        count: 3,
        tags: ['k8-tag']
      )
      as_hash = DropletKit::KubernetesNodePoolMapping.hash_for(:create, node_pool)
      expect(as_hash['name']).to eq(node_pool.name)
      expect(as_hash['size']).to eq(node_pool.size)
      expect(as_hash['count']).to eq(node_pool.count)
      expect(as_hash['tags']).to eq(node_pool.tags)

      as_string = DropletKit::KubernetesNodePoolMapping.representation_for(:create, node_pool)
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools", :post).with(body: as_string).to_return(body: api_fixture('kubernetes/cluster_node_pool_create'), status: 202)
      new_node_pool = resource.cluster_node_pool_create(node_pool, id: cluster_id)

      expect(new_node_pool).to be_kind_of(DropletKit::KubernetesNodePool)
      expect(new_node_pool.name).to eq 'frontend'
      expect(new_node_pool.size).to eq 's-1vcpu-1gb'
      expect(new_node_pool.count).to eq 3
      expect(new_node_pool.tags).to eq ['k8-tag']
      expect(new_node_pool.nodes.length).to eq 3
      new_node_pool.nodes.each do |node|
        expect(node['name']).to eq ""
        expect(node['status']['state']).to eq 'provisioning'
      end
    end
  end


  describe "cluster_node_pool_update" do
    it "should update an existing node_pool" do
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools", :get).to_return(body: api_fixture('kubernetes/cluster_node_pools'))
      node_pools = resource.cluster_node_pools(id: cluster_id)
      node_pools.each do |pool|
        expect(pool).to be_kind_of(DropletKit::KubernetesNodePool)
      end
      node_pool_id = "0a209365-2fac-465e-a959-bb91f232923a"
      expect(node_pools.length).to eq 1
      expect(node_pools.first["id"]).to eq node_pool_id
      expect(node_pools.first["name"]).to eq "k8s-1-12-1-do-1-nyc1-1540837045848-1"
      expect(node_pools.first["size"]).to eq "s-4vcpu-8gb"
      expect(node_pools.first["count"]).to eq 2
      expect(node_pools.first["tags"]).to eq [ "omar-left-his-mark" ]

      node_pool = node_pools.first
      node_pool.name = 'backend'
      node_pool.size = 's-1vcpu-1gb'
      node_pool.count = 2
      node_pool.tags = ['updated-k8-tag']
      as_string = DropletKit::KubernetesNodePoolMapping.representation_for(:update, node_pool)
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools/#{node_pool_id}", :put).with(body: as_string).to_return(body: api_fixture('kubernetes/cluster_node_pool_update'), status: 200)
      updated_node_pool = resource.cluster_node_pool_update(node_pool, id: cluster_id, pool_id: node_pool_id)

      expect(updated_node_pool.id).to eq node_pool_id
      expect(updated_node_pool.name).to eq 'backend'
      expect(updated_node_pool.size).to eq 's-1vcpu-1gb'
      expect(updated_node_pool.count).to eq 2
      expect(updated_node_pool.tags).to eq ['backend']
      expect(updated_node_pool.nodes.length).to eq 2
    end
  end

  describe 'cluster_node_pool_delete' do
    it 'should delete a clusters node_pool' do
      node_pool_id = "f9f16e5a-83b8-4c9b-acf1-4f91492a6652"
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools/#{node_pool_id}", :delete).to_return(status: 202)
      deleted_node_pool = resource.cluster_node_pool_delete(id: cluster_id, pool_id: node_pool_id)

      expect(deleted_node_pool).to eq true
    end
  end

  describe 'cluster_node_pool_recycle' do
    it 'should recycle the clusters node_pool' do
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools", :get).to_return(body: api_fixture('kubernetes/cluster_node_pools'))
      node_pools = resource.cluster_node_pools(id: cluster_id)
      node_pools.each do |pool|
        expect(pool).to be_kind_of(DropletKit::KubernetesNodePool)
      end
      node_pool_id = "0a209365-2fac-465e-a959-bb91f232923a"
      expect(node_pools.length).to eq 1
      expect(node_pools.first["id"]).to eq node_pool_id
      expect(node_pools.first["name"]).to eq "k8s-1-12-1-do-1-nyc1-1540837045848-1"
      expect(node_pools.first["count"]).to eq 2

      nodes = node_pools.first.nodes
      expect(nodes.length).to eq 2
      node_ids = nodes.map(&:id)
      recycle_json = { nodes: node_ids}.to_json
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools/#{node_pool_id}/recycle", :post).with(body: recycle_json).to_return(status: 202)
      response = resource.cluster_node_pool_recycle(node_ids, id: cluster_id, pool_id: node_pool_id)

      expect(response).to eq true
    end
  end

  describe 'get_options' do
    it 'should get the kubernetes options' do
      stub_do_api("/v2/kubernetes/options", :get).to_return(body: api_fixture('kubernetes/options'))
      options = resource.get_options
      expect(options).to be_kind_of(DropletKit::KubernetesOptions)
      expect(options.versions.length).to eq 7
      options.versions.each do |version|
        expect(version).to be_kind_of(DropletKit::KubernetesOptionsMapping::Version)
        expect(version.slug).to be_present
        expect(version.kubernetes_version).to be_present
      end
    end
  end
end

