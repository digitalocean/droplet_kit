module DropletKit
  class KubernetesMaintenancePolicyMapping
    include Kartograph::DSL
    kartograph do
      mapping KubernetesMaintenancePolicyMapping

      property :id, scopes: [:read]
      property :name, scopes: [:read]
    end
  end
end
