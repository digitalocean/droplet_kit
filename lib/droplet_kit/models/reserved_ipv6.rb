# frozen_string_literal: true

module DropletKit
  class ReservedIpv6 < BaseModel
    attribute :ip
    attribute :droplet
    attribute :reserved_at
    # Used for creates
    attribute :region_slug

    def identifier
      ip
    end

    def self.from_identifier(identifier)
      new(ip: identifier)
    end
  end
end
