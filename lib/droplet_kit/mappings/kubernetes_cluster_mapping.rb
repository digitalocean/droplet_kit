# frozen_string_literal: true

module DropletKit
  class KubernetesClusterMapping
    include Kartograph::DSL
    kartograph do
      mapping KubernetesCluster
      root_key plural: 'kubernetes_clusters', singular: 'kubernetes_cluster', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: %i[read update create]
      property :region, scopes: %i[read create]
      property :version, scopes: %i[read create]
      property :auto_upgrade, scopes: %i[read update create]
      property :cluster_subnet, scopes: [:read]
      property :service_subnet, scopes: [:read]
      property :ipv4, scopes: [:read]
      property :endpoint, scopes: [:read]
      property :tags, scopes: %i[read update create]
      property :maintenance_policy, scopes: %i[read update create]
      property :node_pools, scopes: %i[read create]
      property :vpc_uuid, scopes: %i[read create]
      property :ha, scopes: %i[read create]
    end
  end
end
