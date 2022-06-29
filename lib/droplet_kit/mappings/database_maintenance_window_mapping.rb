# frozen_string_literal: true

module DropletKit
  class DatabaseMaintenanceWindowMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseMaintenanceWindow
      root_key singular: 'database_maintenance_window', plural: 'database_maintenance_windows', scopes: [:read]

      property :day, scopes: %i[read update]
      property :hour, scopes: %i[read update]
      property :pending, scopes: [:read]
      property :description, scopes: [:read]
    end
  end
end
