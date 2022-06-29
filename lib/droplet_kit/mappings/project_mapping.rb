# frozen_string_literal: true

module DropletKit
  class ProjectMapping
    include Kartograph::DSL

    kartograph do
      mapping Project
      root_key plural: 'projects', singular: 'project', scopes: [:read]

      property :id, scopes: [:read]
      property :owner_uuid, scopes: [:read]
      property :owner_id, scopes: [:read]

      property :name, scopes: %i[read create update]
      property :description, scopes: %i[read create update]
      property :purpose, scopes: %i[read create update]
      property :environment, scopes: %i[read create update]
      property :is_default, scopes: %i[read create update]

      property :created_at, scopes: [:read]
      property :updated_at, scopes: [:read]
    end
  end
end
