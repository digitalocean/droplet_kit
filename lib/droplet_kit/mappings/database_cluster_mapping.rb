module DropletKit
  class DatabaseClusterMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseCluster
      root_key singular: 'database', plural: 'databases', scopes: [:read]

      property :id, scopes: [:read]
      property :name, scopes: [:read, :create, :restore]
      property :engine, scopes: [:read, :create, :restore]
      property :version, scopes: [:read, :create, :restore]
      property :connection, scopes: [:read], include: DatabaseConnectionMapping
      property :private_connection, scopes: [:read], include: DatabaseConnectionMapping
      property :users, plural: true, scopes: [:read], include: DatabaseUserMapping
      property :backup_restore, scopes: [:restore], include: DatabaseBackupRestoreMapping
      property :num_nodes, scopes: [:read, :create, :resize, :restore]
      property :size, scopes: [:read, :create, :resize, :restore]
      property :db_names, plural: true, scopes: [:read]
      property :region, scopes: [:read, :create, :migrate, :restore]
      property :status, scopes: [:read]
      property :maintenance_window, scopes: [:read], include: DatabaseMaintenanceWindowMapping
      property :created_at, scopes: [:read]
      property :private_network_uuid, scopes: [:read, :create]
      property :tags, plural: true, scopes: [:read, :create]
    end
  end
end
