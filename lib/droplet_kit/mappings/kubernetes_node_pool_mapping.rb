module DropletKit
  class KubernetesNodePoolMapping
    include Kartograph::DSL

    kartograph do
      mapping KubernetesNodePool
      root_key plural: 'node_pools', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :size, scopes: [:read]
      property :count, scopes: [:read]
      property :tags, scopes: [:read]

      property :nodes, plural: true, scopes: [:read], include: KubernetesNodeMapping
    end
  end
end

