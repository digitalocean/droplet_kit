module DropletKit
  class Region < BaseModel
    attribute :slug
    attribute :name
    attribute :sizes
    attribute :available
    attribute :features
  end

  def self.from_identifier(identifier)
    new(slug: identifier)
  end
end
