module DropletKit
  class TaggedResources < BaseModel
    attribute :count
    attribute :last_tagged_uri
    attribute :droplets
    attribute :images
  end
end
