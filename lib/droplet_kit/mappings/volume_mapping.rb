module DropletKit
  class VolumeMapping
    include Kartograph::DSL

    kartograph do
      mapping Volume
      root_key plural: 'volumes', singular: 'volume', scopes: [:read]

      property :id, scopes: [:read]
      property :region, scopes: [:read], include: RegionMapping
      property :droplet_ids, scopes: [:read]
      property :name, scopes: [:read, :create]
      property :description, scopes: [:read, :create]
      property :size_gigabytes, scopes: [:read, :create]
      property :created_at, scopes: [:read]

      property :region, scopes: [:create]
      property :snapshot_id, scopes: [:create]
    end
  end
end

