# frozen_string_literal: true

module DropletKit
  class VolumeMapping
    include Kartograph::DSL

    kartograph do
      mapping Volume
      root_key plural: 'volumes', singular: 'volume', scopes: [:read]

      property :id, scopes: [:read]
      property :region, scopes: [:read], include: RegionMapping
      property :droplet_ids, scopes: [:read]
      property :name, scopes: %i[read create]
      property :description, scopes: %i[read create]
      property :size_gigabytes, scopes: %i[read create]
      property :created_at, scopes: [:read]

      property :region, scopes: [:create]
      property :snapshot_id, scopes: [:create]
      property :filesystem_type, scopes: %i[read create]
      property :filesystem_label, scopes: %i[read create]
    end
  end
end
