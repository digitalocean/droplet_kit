module DropletKit
  class KubernetesClusterResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/kubernetes/clusters' do
        query_keys :per_page, :page, :tag_name
        handler(200) { |response| KubernetesClusterMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/kubernetes/clusters/:id' do
        handler(200) { |response| KubernetesClusterMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/kubernetes/clusters' do
        body { |object| KubernetesClusterMapping.representation_for(:create, object) }
        handler(201) { |response, cluster| KubernetesClusterMapping.extract_into_object(cluster, response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :kubeconfig, 'GET /v2/kubernetes/clusters/:id/kubeconfig' do
        handler(200) { |response| response.body }
      end

      action :update, 'PUT /v2/kubernetes/clusters/:id' do
        body { |cluster| KubernetesClusterMapping.representation_for(:update, cluster) }
        handler(202) { |response| KubernetesClusterMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :delete, 'DELETE /v2/kubernetes/clusters/:id' do
        handler(202) { |response| true }
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

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
