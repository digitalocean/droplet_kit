# frozen_string_literal: true

module DropletKit
  class DatabaseClusterMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseCluster
      root_key singular: 'database', plural: 'databases', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: %i[read create restore]
      property :engine, scopes: %i[read create restore]
      property :version, scopes: %i[read create restore]
      property :connection, scopes: [:read], include: DatabaseConnectionMapping
      property :private_connection, scopes: [:read], include: DatabaseConnectionMapping
      property :users, plural: true, scopes: [:read], include: DatabaseUserMapping
      property :backup_restore, scopes: [:restore], include: DatabaseBackupRestoreMapping
      property :num_nodes, scopes: %i[read create resize restore]
      property :size, scopes: %i[read create resize restore]
      property :db_names, plural: true, scopes: [:read]
      property :region, scopes: %i[read create migrate restore]
      property :status, scopes: [:read]
      property :maintenance_window, scopes: [:read], include: DatabaseMaintenanceWindowMapping
      property :created_at, scopes: [:read]
      property :private_network_uuid, scopes: %i[read create]
      property :tags, plural: true, scopes: %i[read create]
    end
  end
end
