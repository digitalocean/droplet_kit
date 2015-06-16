module DropletKit
  class Size < BaseModel
    attribute :slug
    attribute :memory
    attribute :vcpus
    attribute :disk
    attribute :transfer
    attribute :price_monthly
    attribute :price_hourly
    attribute :regions
    attribute :available
  end
end
