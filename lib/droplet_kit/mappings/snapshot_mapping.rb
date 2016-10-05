module DropletKit
  class SnapshotMapping
    include Kartograph::DSL

    kartograph do
      root_key plural: 'snapshots', singular: 'snapshot', scopes: [:read]
      mapping Snapshot

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :regions, scopes: [:read]
      property :created_at, scopes: [:read]
      property :resource_id, scopes: [:read]
      property :resource_type, scopes: [:read]
      property :min_disk_size, scopes: [:read]
      property :size_gigabytes, scopes: [:read]
    end
  end
end