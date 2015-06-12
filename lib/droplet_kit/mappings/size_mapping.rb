module DropletKit
  class SizeMapping
    include Kartograph::DSL

    kartograph do
      mapping Size
      root_key singular: 'size', plural: 'sizes', scopes: [:read]

      property :slug, scopes: [:read]
      property :memory, scopes: [:read]
      property :vcpus, scopes: [:read]
      property :disk, scopes: [:read]
      property :transfer, scopes: [:read]
      property :price_monthly, scopes: [:read]
      property :price_hourly, scopes: [:read]
      property :regions, scopes: [:read]
      property :available, scopes: [:read]
    end
  end
end
