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

      action :cluster_node_pools, 'GET /v2/kubernetes/clusters/:id/node_pools' do
        handler(200) { |response| KubernetesNodePoolMapping.extract_collection(response.body, :read) }
      end

      action :cluster_node_pool_find, 'GET /v2/kubernetes/clusters/:id/node_pools/:pool_id' do
        handler(200) { |response| KubernetesNodePoolMapping.extract_single(response.body, :read) }
      end

      action :cluster_node_pool_create, 'POST /v2/kubernetes/clusters/:id/node_pools' do
        body { |node_pool| KubernetesNodePoolMapping.representation_for(:create, node_pool) }
        handler(202) { |response| KubernetesNodePoolMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :cluster_node_pool_update, 'PUT /v2/kubernetes/clusters/:id/node_pools/:pool_id' do
        body { |node_pool| KubernetesNodePoolMapping.representation_for(:update, node_pool) }
        handler(200) { |response| KubernetesNodePoolMapping.extract_single(response.body, :read) }
        handler(404) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :cluster_node_pool_delete, 'DELETE /v2/kubernetes/clusters/:id/node_pools/:pool_id' do
        handler(202) { |response| true }
      end

      action :cluster_node_pool_recycle, 'POST /v2/kubernetes/clusters/:id/node_pools/:pool_id/recycle' do
        body { |node_ids| { nodes: node_ids }.to_json }
        handler(202) { |response| true }
        handler(404) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :get_options, 'GET /v2/kubernetes/options' do
        handler(200) { |response| KubernetesOptionsMapping.extract_single(response.body, :read) }
      end
    end
  end
end
