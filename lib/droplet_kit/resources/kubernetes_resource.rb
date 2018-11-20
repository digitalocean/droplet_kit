module DropletKit
  class KubernetesResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/kubernetes/clusters' do
        query_keys :per_page, :page, :tag_name
        handler(200) { |response| KubernetesMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/kubernetes/clusters/:id' do
        handler(200) { |response| KubernetesMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/kubernetes/clusters' do
      end

      action :config, 'GET /v2/kubernetes/clusters/:cluster_id/kubeconfig' do
      end

      action :update, 'PUT /v2/kubernetes/clusters/:id' do
        body { |cluster| KubernetesMapping.representation_for(:update, cluster) }
        handler(202) { |response| KubernetesMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :upgrade, 'GET /v2/kubernetes/clusters/:cluster_id/upgrade' do
      end

      action :delete, 'DELETE /v2/kubernetes/clusters/:cluster_id' do
      end

      action :cluster_node_pools, 'GET /v2/kubernetes/clusters/:cluster_id/node_pools' do
      end

      action :cluster_find_node_pool, 'GET /v2/kubernetes/clusters/:cluster_id/node_pools/:pool_id' do
      end

      action :cluster_node_pool_create, 'POST /v2/kubernetes/clusters/:cluster_id/node_pools' do
      end

      action :cluster_node_pool_update, 'PUT /v2/kubernetes/clusters/:cluster_id/node_pools/:pool_id' do
      end

      action :cluster_node_pool_delete, 'DELETE /v2/kubernetes/clusters/:cluster_id/node_pools/:pool_id' do
      end

      action :cluster_node_pool_recycle, 'POST /v2/kubernetes/clusters/:cluster_id/node_pools/:pool_id/recycle' do
      end

      action :get_options, 'GET /v2/kubernetes/options' do
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
