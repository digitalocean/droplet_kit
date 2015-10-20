module DropletKit
  class FloatingIpMapping
    include Kartograph::DSL

    kartograph do
      mapping FloatingIp
      root_key plural: 'floating_ips', singular: 'floating_ip', scopes: [:read]

      property :ip, scopes: [:read]

      property :region, scopes: [:read], include: RegionMapping
      property :droplet, scopes: [:read], include: DropletMapping

      # Create properties aren't quite the same
      property :droplet_id, scopes: [:create]
      property :region, scopes: [:create]
    end
  end
end