# frozen_string_literal: true

module DropletKit
  class ReservedIpMapping
    include Kartograph::DSL

    kartograph do
      mapping ReservedIp
      root_key plural: 'reserved_ips', singular: 'reserved_ip', scopes: [:read]

      property :ip, scopes: [:read]

      property :region, scopes: [:read], include: RegionMapping
      property :droplet, scopes: [:read], include: DropletMapping

      # Create properties aren't quite the same
      property :droplet_id, scopes: [:create]
      property :region, scopes: [:create]
    end
  end
end
