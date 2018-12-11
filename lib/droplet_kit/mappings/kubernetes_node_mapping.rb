module DropletKit
  class KubernetesNodeMapping
    include Kartograph::DSL
    kartograph do
      mapping KubernetesNode

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :status, scopes: [:read]
      property :created_at, scopes: [:read]
      property :updated_at, scopes: [:read]
    end
  end
end

