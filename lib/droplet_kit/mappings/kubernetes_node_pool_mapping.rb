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

      property :nodes, plural: true, scopes: [:read], include: KubernetesNodeMapping

      # Create properties
      property :name, scopes: [:create, :update]
      property :size, scopes: [:create, :update]
      property :count, scopes: [:create, :update]
      property :tags, scopes: [:create, :update]

      # recycle
      property :nodes, plural: true, scopes: [:recycle]
    end
  end
end

