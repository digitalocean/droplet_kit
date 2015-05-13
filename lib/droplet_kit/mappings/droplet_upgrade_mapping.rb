module DropletKit
  class DropletUpgradeMapping
    include Kartograph::DSL

    kartograph do
      mapping DropletUpgrade

      property :droplet_id, scopes: [:read]
      property :date_of_migration, scopes: [:read]
    end
  end
end