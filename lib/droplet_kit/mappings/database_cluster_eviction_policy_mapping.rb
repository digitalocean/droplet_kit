module DropletKit
  class DatabaseClusterEvictionPolicyMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterEvictionPolicy
      scoped :read, :create do
        property :eviction_policy
      end
    end
  end
end