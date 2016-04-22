module DropletKit
  class Drive < BaseModel
    attribute :id
    attribute :region
    attribute :droplet_ids
    attribute :name
    attribute :description
    attribute :size_gigabytes
    attribute :created_at
  end
end