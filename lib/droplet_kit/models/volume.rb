module DropletKit
  class Volume < BaseModel
    attribute :id
    attribute :region
    attribute :droplet_ids
    attribute :name
    attribute :description
    attribute :size_gigabytes
    attribute :created_at

    # Used for creates
    attribute :snapshot_id
  end
end