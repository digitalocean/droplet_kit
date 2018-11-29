module DropletKit
  class KubernetesResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/kubernetes/clusters' do
      end

      action :find, 'GET /v2/kubernetes/clusters/:cluster_id' do
      end

      action :create, 'POST /v2/kubernetes/clusters' do
      end

      action :config, 'GET /v2/kubernetes/clusters/:cluster_id/kubeconfig' do
      end

      action :update, 'PUT /v2/kubernetes/clusters/:cluster_id' do
      end

      action :upgrade, 'GET /v2/kubernetes/clusters/:cluster_id/upgrade' do
      end

      action :delete, 'DELETE /v2/kubernetes/clusters/:cluster_id' do
      end

      action :node_pools, 'GET /v2/kubernetes/clusters/:id/node_pools' do
        handler(200) { |response| KubernetesNodePoolMapping.extract_collection(response.body, :read) }
      end

      action :find_node_pool, 'GET /v2/kubernetes/clusters/:id/node_pools/:pool_id' do
        handler(200) { |response| KubernetesNodePoolMapping.extract_single(response.body, :read) }
      end

      action :create_node_pool, 'POST /v2/kubernetes/clusters/:id/node_pools' do
        body { |node_pool| KubernetesNodePoolMapping.representation_for(:create, node_pool) }
        handler(201) { |response| KubernetesNodePoolMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update_node_pool, 'PUT /v2/kubernetes/clusters/:id/node_pools/:pool_id' do
        body { |node_pool| KubernetesNodePoolMapping.representation_for(:update, node_pool) }
        handler(202) { |response| KubernetesNodePoolMapping.extract_single(response.body, :read) }
        handler(404) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :delete_node_pool, 'DELETE /v2/kubernetes/clusters/:id/node_pools/:pool_id' do
        handler(202) { |response| true }
      end

      action :recycle_node_pool, 'POST /v2/kubernetes/clusters/:id/node_pools/:pool_id/recycle' do
        body { |node_ids| { nodes: node_ids }.to_json }
        handler(202) { |response| true }
        handler(404) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end
    end
  end
end
