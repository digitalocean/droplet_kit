module DropletKit
  class FirewallRule < BaseModel
    attribute :inbound_rules
    attribute :outbound_rules
  end
end
