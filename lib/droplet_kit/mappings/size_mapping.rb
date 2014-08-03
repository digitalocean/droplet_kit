module DropletKit
  class SizeMapping
    include Kartograph::DSL

    kartograph do
      mapping Size

      property :slug, scopes: [:read]
      property :transfer, scopes: [:read]
      property :price_monthly, scopes: [:read]
      property :price_hourly, scopes: [:read]
    end
  end
end