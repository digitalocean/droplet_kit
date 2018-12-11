module DropletKit
  class FloatingIp < BaseModel
    attribute :ip
    attribute :region
    attribute :droplet

    # Used for creates
    attribute :droplet_id

    def identifier
      ip
    end

    def self.from_identifier(identifier)
      new(ip: identifier)
    end
  end
end
