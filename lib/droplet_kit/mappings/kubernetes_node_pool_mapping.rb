# frozen_string_literal: true

module DropletKit
  class KubernetesNodePoolMapping
    include Kartograph::DSL
    kartograph do
      mapping KubernetesNodePool
      root_key plural: 'node_pools', singular: 'node_pool', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :size, scopes: [:read]
      property :count, scopes: [:read]
      property :tags, scopes: [:read]
      property :labels, scopes: [:read]
      property :auto_scale, scopes: [:read]
      property :min_nodes, scopes: [:read]
      property :max_nodes, scopes: [:read]

      property :nodes, plural: true, scopes: [:read], include: KubernetesNodeMapping

      # Create properties
      property :name, scopes: %i[create update]
      property :size, scopes: %i[create update]
      property :count, scopes: %i[create update]
      property :tags, scopes: %i[create update]
      property :labels, scopes: %i[create update]
      property :auto_scale, scopes: %i[create update]
      property :min_nodes, scopes: %i[create update]
      property :max_nodes, scopes: %i[create update]

      # recycle
      property :nodes, plural: true, scopes: [:recycle]
    end
  end
end
