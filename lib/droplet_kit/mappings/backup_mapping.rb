module DropletKit
  class BackupMapping
    include Kartograph::DSL

    kartograph do
      root_key plural: 'backups', singular: 'backup', scopes: [:read]
      mapping Backup

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :distribution, scopes: [:read]
      property :slug, scopes: [:read]
      property :public, scopes: [:read]
      property :regions, scopes: [:read]
      property :action_ids, scopes: [:read]
      property :created_at, scopes: [:read]
    end
  end
end