module DropletKit
  class DatabaseClusterEvictionPolicyMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterEvictionPolicy
      scoped :read, :update do
        property :eviction_policy
      end
    end
  end
end