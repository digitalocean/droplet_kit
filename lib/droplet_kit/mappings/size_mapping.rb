module DropletKit
  class SizeMapping
    include Kartograph::DSL

    kartograph do
      mapping Size
      root_key singular: 'size', plural: 'sizes', scopes: [:read]

      property :slug, scopes: [:read]
      property :transfer, scopes: [:read]
      property :price_monthly, scopes: [:read]
      property :price_hourly, scopes: [:read]
    end
  end
end