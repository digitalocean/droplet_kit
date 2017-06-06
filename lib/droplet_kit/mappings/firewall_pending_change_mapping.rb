module DropletKit
  class FirewallPendingChangeMapping
    include Kartograph::DSL

    kartograph do
      mapping FirewallPendingChange
      root_key plural: 'pending_changes', scopes: [:read]

      scoped :read do
        property :droplet_id
        property :removing
        property :status
      end
    end
  end
end
