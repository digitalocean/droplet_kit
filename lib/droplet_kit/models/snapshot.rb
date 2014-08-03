module DropletKit
  class Snapshot < BaseModel
    attribute :id
    attribute :name
    attribute :distribution
    attribute :slug
    attribute :public
    attribute :regions
    attribute :action_ids
    attribute :created_at
  end
end