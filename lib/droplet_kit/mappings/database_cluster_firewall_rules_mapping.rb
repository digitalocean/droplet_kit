module DropletKit
  class DatabaseClusterFirewallRulesMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterFirewallRules
      root_key plural: 'rules', scopes: [:read, :update]
    
      scoped :read, :update do
        property :type
        property :value
      end

      scoped :read do
        property :uuid
        property :cluster_uuid
        property :created_at
      end
    end
  end
end