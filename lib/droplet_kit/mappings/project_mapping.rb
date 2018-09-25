module DropletKit
  class ProjectMapping
    include Kartograph::DSL

    kartograph do
      mapping Project
      root_key plural: 'projects', singular: 'project', scopes: [:read]

      property :id, scopes: [:read]
      property :owner_uuid, scopes: [:read]
      property :owner_id, scopes: [:read]

      property :name, scopes: [:read, :create, :update]
      property :description, scopes: [:read, :create, :update]
      property :purpose, scopes: [:read, :create, :update]
      property :environment, scopes: [:read, :create, :update]
      property :is_default, scopes: [:read, :create, :update]

      property :created_at, scopes: [:read]
      property :updated_at, scopes: [:read]
    end
  end
end
