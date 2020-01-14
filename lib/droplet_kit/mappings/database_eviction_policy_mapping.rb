module DropletKit
  class DatabaseEvictionPolicyMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseEvictionPolicy

      property :eviction_policy, scopes: [:read, :update]
    end
  end
end
