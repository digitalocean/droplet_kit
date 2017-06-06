module DropletKit
  class FirewallMapping
    include Kartograph::DSL

    kartograph do
      mapping Firewall
      root_key singular: 'firewall', plural: 'firewalls', scopes: [:read]

      scoped :read do
        property :id
        property :status
        property :created_at
        property :pending_changes, plural: true, include: FirewallPendingChangeMapping
      end

      scoped :read, :create, :update do
        property :name
        property :inbound_rules, plural: true, include: FirewallInboundRuleMapping
        property :outbound_rules, plural: true, include: FirewallOutboundRuleMapping
        property :droplet_ids
        property :tags
      end
    end
  end
end
