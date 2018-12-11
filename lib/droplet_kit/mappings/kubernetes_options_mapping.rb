module DropletKit
  class KubernetesOptionsMapping
    include Kartograph::DSL
    kartograph do
      mapping KubernetesOptions
      root_key singular: 'options', scopes: [:read]

      Version = Struct.new(:slug, :kubernetes_version)
      property :versions, plural: true, scopes: [:read] do
        mapping Version
        property :slug, scopes: [:read]
        property :kubernetes_version, scopes: [:read]
      end

      Region = Struct.new(:name, :slug)
      property :regions, plural: true, scopes: [:read] do
        mapping Region
        property :name, scopes: [:read]
        property :slug, scopes: [:read]
      end

      Size = Struct.new(:name, :slug)
      property :sizes, plural: true, scopes: [:read] do
        mapping Size
        property :name, scopes: [:read]
        property :slug, scopes: [:read]
      end
    end
  end
end
