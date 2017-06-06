module DropletKit
  class FirewallPendingChange < BaseModel
    attribute :droplet_id
    attribute :removing
    attribute :status
  end
end
