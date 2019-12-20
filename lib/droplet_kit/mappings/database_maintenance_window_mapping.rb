module DropletKit
  class DatabaseMaintenanceWindowMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseMaintenanceWindow
      root_key singular: 'database_maintenance_window', plural: 'database_maintenance_windows', scopes: [:read]

      property :day, scopes: [:read, :update]
      property :hour, scopes: [:read, :update]
      property :pending, scopes: [:read]
      property :description, scopes: [:read]
    end
  end
end
