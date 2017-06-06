module DropletKit
  class FirewallOutboundRuleMapping
    include Kartograph::DSL

    kartograph do
      mapping FirewallOutboundRule
      root_key plural: 'outbound_rules', scopes: [:read, :create, :update]

      scoped :read, :create, :update do
        property :protocol
        property :ports
        property :destinations
      end
    end
  end
end
