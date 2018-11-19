require 'spec_helper'

RSpec.describe DropletKit::KubernetesResource do
  subject(:resource) { described_class.new(connection: connection) }
  let(:kubernetes_node_pool_attributes) { DropletKit::KubernetesNodePool.new.attributes }
  include_context 'resources'

  describe "cluster_node_pools" do
    it 'returns the node_pools for a cluster' do
      cluster_id = 42
      stub_do_api("/v2/kubernetes/clusters/#{cluster_id}/node_pools", :get).to_return(body: api_fixture('kubernetes/cluster_node_pools'))
      node_pools= resource.cluster_node_pools(cluster_id: cluster_id)
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

end

