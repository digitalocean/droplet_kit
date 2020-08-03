module DropletKit
  class DatabaseFirewallRuleMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseFirewallRule
      root_key plural: 'rules', scopes: [:read, :update]

      property :type, scopes: [:read, :update]
      property :value, scopes: [:read, :update]
      property :uuid, scopes: [:read]
      property :cluster_uuid, scopes: [:read]
      property :created_at, scopes: [:read]
    end
  end
end
