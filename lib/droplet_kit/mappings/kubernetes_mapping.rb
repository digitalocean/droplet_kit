module DropletKit
  class KubernetesMapping
    include Kartograph::DSL
    kartograph do
      mapping Kubernetes
      root_key plural: 'kubernetes_clusters', singular: 'kubernetes_cluster', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read, :create, :update]
      property :region, scopes: [:read, :create]
      property :version, scopes: [:read, :create]
      property :cluster_subnet, scopes: [:read]
      property :service_subnet, scopes: [:read]
      property :ipv4, scopes: [:read]
      property :endpoint, scopes: [:read]
      property :tags, scopes: [:read, :create, :update]
      property :node_pools, scopes: [:read, :create]
    end
  end
end
