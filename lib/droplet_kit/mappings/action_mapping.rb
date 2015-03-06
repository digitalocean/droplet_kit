module DropletKit
  class ActionMapping
    include Kartograph::DSL

    kartograph do
      mapping Action
      root_key plural: 'actions', singular: 'action', scopes: [:read]

      property :id, scopes: [:read]
      property :status, scopes: [:read]
      property :type, scopes: [:read]
      property :started_at, scopes: [:read]
      property :completed_at, scopes: [:read]
      property :resource_id, scopes: [:read]
      property :resource_type, scopes: [:read]
      property :region, scopes: [:read], include: RegionMapping
      property :region_slug, scopes: [:read]
    end
  end
end
