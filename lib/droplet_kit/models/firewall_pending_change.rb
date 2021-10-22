# frozen_string_literal: true

module DropletKit
  class FirewallPendingChange < BaseModel
    attribute :droplet_id
    attribute :removing
    attribute :status
  end
end
