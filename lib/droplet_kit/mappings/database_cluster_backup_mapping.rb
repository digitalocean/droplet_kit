module DropletKit
  class DatabaseClusterBackupMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterBackup
      root_key plural: 'backups', scopes: [:read]

      scoped :read do
        property :created_at
        property :size_gigabytes
      end
    end
  end
end