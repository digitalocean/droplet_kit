module DropletKit
  class KubernetesClusterMapping
    include Kartograph::DSL
    kartograph do
      mapping KubernetesCluster
      root_key plural: 'kubernetes_clusters', singular: 'kubernetes_cluster', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read, :update, :create]
      property :region, scopes: [:read, :create]
      property :version, scopes: [:read, :create]
      property :cluster_subnet, scopes: [:read]
      property :service_subnet, scopes: [:read]
      property :ipv4, scopes: [:read]
      property :endpoint, scopes: [:read]
      property :tags, scopes: [:read, :update, :create]
      property :node_pools, plural: true, scopes: [:create, :update, :read], include: DropletKit::KubernetesNodePoolMapping
    end
  end
end
