# frozen_string_literal: true

module DropletKit
  class DropletUpgrade < BaseModel
    attribute :droplet_id
    attribute :date_of_migration
  end
end
