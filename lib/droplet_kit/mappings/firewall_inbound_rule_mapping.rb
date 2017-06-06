module DropletKit
  class FirewallInboundRuleMapping
    include Kartograph::DSL

    kartograph do
      mapping FirewallInboundRule
      root_key plural: 'inbound_rules', scopes: [:read, :create, :update]

      scoped :read, :create, :update do
        property :protocol
        property :ports
        property :sources
      end
    end
  end
end
