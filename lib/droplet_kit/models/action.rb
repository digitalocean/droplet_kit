module DropletKit
  class Action < BaseModel
    attribute :id
    attribute :status
    attribute :type
    attribute :started_at
    attribute :completed_at
    attribute :resource_id
    attribute :resource_type
    attribute :region
    attribute :region_slug
  end
end
