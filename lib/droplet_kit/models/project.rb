module DropletKit
  class Project < BaseModel
    DEFAULT = 'default'.freeze

    attribute :id
    attribute :owner_uuid
    attribute :owner_id
    attribute :name
    attribute :description
    attribute :purpose
    attribute :environment
    attribute :is_default
    attribute :created_at
    attribute :updated_at

    def self.from_identifier(identifier)
      new(uuid: identifier)
    end
  end
end
