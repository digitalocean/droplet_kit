# frozen_string_literal: true

module DropletKit
  class ReservedIpv6Mapping
    include Kartograph::DSL

    kartograph do
      mapping ReservedIpv6
      root_key plural: 'reserved_ipv6s', singular: 'reserved_ipv6', scopes: [:read]

      property :ip, scopes: [:read]
      property :region_slug, scopes: %i[read create]
      property :droplet, scopes: [:read], include: DropletMapping
      property :reserved_at, scopes: [:read]
    end
  end
end
