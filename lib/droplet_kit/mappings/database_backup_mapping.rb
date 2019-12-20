module DropletKit
  class DatabaseBackupMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseBackup
      root_key singular: 'backup', plural: 'backups', scopes: [:read]

      property :created_at, scopes: [:read]
      property :size_gigabytes, scopes: [:read]
    end
  end
end
