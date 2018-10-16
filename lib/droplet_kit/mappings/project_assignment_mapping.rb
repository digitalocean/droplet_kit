module DropletKit
  class ProjectAssignmentMapping
    include Kartograph::DSL

    kartograph do
      mapping ProjectAssignment
      root_key plural: 'resources', singular: 'resource', scopes: [:read]

      property :urn, scopes: [:read, :create]
      property :assigned_at, scopes: [:read]

      property :links, scopes: [:read] do
        mapping Links
        property :myself, key: 'self', scopes: [:read]
      end
    end
  end
end
