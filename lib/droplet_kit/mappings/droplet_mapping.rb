module DropletKit
  class DropletMapping
    include Kartograph::DSL

    kartograph do
      mapping Droplet
      root_key plural: 'droplets', singlular: 'droplet', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :memory, scopes: [:read]
      property :vcpus, scopes: [:read]
      property :disk, scopes: [:read]
      property :locked, scopes: [:read]
      property :created_at, scopes: [:read]
      property :status, scopes: [:read]
      property :backup_ids, scopes: [:read]
      property :snapshot_ids, scopes: [:read]
      property :action_ids, scopes: [:read]
      property :features, scopes: [:read]

      property :region, scopes: [:read] do
        mapping Region

        property :slug, scopes: [:read]
        property :name, scopes: [:read]
        property :sizes, scopes: [:read]
        property :available, scopes: [:read]
        property :features, scopes: [:read]
      end

      property :image, scopes: [:read] do
        mapping Image

        property :id, scopes: [:read]
        property :name, scopes: [:read]
        property :distribution, scopes: [:read]
        property :slug, scopes: [:read]
        property :public, scopes: [:read]
        property :regions, scopes: [:read]
      end

      property :size, scopes: [:read] do
        mapping Size

        property :slug, scopes: [:read]
        property :transfer, scopes: [:read]
        property :price_monthly, scopes: [:read]
        property :price_hourly, scopes: [:read]
      end

      property :networks do
        mapping NetworkMap
        property :v4
        property :v6
      end
    end
  end
end