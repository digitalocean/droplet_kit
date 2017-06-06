module DropletKit
  class FirewallRuleMapping
    include Kartograph::DSL

    kartograph do
      mapping FirewallRule

      scoped :create, :update do
        property :inbound_rules, plural: true, include: FirewallInboundRuleMapping
        property :outbound_rules, plural: true, include: FirewallOutboundRuleMapping
      end
    end
  end
end
