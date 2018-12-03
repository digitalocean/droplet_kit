module DropletKit
  class KubernetesClustersResource < ResourceKit::Resource
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
