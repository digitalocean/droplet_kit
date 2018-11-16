module DropletKit
  class KubernetesMapping
    include Kartograph::DSL
    kartograph do
      mapping Kubernetes
      root_key plural: 'kubernetes_clusters', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :region, scopes: [:read]
    end
  end
end
