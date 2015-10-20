module DropletKit
  class FloatingIp < BaseModel
    attribute :ip
    attribute :region
    attribute :droplet

    # Used for creates
    attribute :droplet_id
  end
end
