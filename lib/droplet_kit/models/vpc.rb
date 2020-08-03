module DropletKit
  class VPC < BaseModel
    attribute :id
    attribute :urn
    attribute :name
    attribute :description
    attribute :ip_range
    attribute :region
    attribute :created_at
    attribute :default
  end
end