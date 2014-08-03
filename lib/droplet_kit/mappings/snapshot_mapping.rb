module DropletKit
  class SnapshotMapping
    include Kartograph::DSL

    kartograph do
      root_key plural: 'snapshots', singular: 'snapshot', scopes: [:read]
      mapping Snapshot

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :distribution, scopes: [:read]
      property :slug, scopes: [:read]
      property :public, scopes: [:read]
      property :regions, scopes: [:read]
      property :action_ids, scopes: [:read]
      property :created_at, scopes: [:read]
    end
  end
end