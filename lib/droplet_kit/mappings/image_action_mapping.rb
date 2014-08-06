module DropletKit
  class ImageActionMapping
    include Kartograph::DSL

    kartograph do
      mapping ImageAction
      root_key singular: 'action', plural: 'actions', scopes: [:read]

      property :id, scopes: [:read]
      property :status, scopes: [:read]
      property :type, scopes: [:read]
      property :started_at, scopes: [:read]
      property :completed_at, scopes: [:read]
      property :resource_id, scopes: [:read]
      property :resource_type, scopes: [:read]
      property :region, scopes: [:read]
    end
  end
end