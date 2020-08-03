module DropletKit
  class DatabaseBackupRestoreMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseBackup
      root_key singular: 'backup_restore', scopes: [:read]

      property :database_name, scopes: [:restore]
      property :backup_created_at, scopes: [:restore]
    end
  end
end
