module DropletKit
  class KubernetesOptionsMapping

    include Kartograph::DSL

    Version = Struct.new(:slug, :kubernetes_version)
    kartograph do
      mapping KubernetesOptions
      root_key singular: 'options', scopes: [:read]
      property :versions, plural: true, scopes: [:read] do
        mapping Version
        property :slug, scopes: [:read]
        property :kubernetes_version, scopes: [:read]
      end
    end
  end
end
