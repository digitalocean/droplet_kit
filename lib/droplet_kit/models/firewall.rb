module DropletKit
  class Firewall < BaseModel
    attribute :id
    attribute :name
    attribute :status
    attribute :created_at
    attribute :inbound_rules
    attribute :outbound_rules
    attribute :droplet_ids
    attribute :tags
    attribute :pending_changes
  end
end
