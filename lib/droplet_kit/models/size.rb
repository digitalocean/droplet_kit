# frozen_string_literal: true

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
    attribute :description
  end

  def self.from_identifier(identifier)
    new(slug: identifier)
  end
end
