module DropletKit
  class KubernetesMapping
    include Kartograph::DSL
    kartograph do
      mapping Kubernetes
      root_key plural: 'kubernetes_clusters', singular: 'kubernetes_cluster', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read, :update]
      property :region, scopes: [:read]
      property :version, scopes: [:read]
      property :cluster_subnet, scopes: [:read]
      property :service_subnet, scopes: [:read]
      property :ipv4, scopes: [:read]
      property :endpoint, scopes: [:read]
      property :tags, scopes: [:read, :update]
      property :node_pools, scopes: [:read]
    end
  end
end
