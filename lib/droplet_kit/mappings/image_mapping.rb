module DropletKit
  class ImageMapping
    include Kartograph::DSL

    kartograph do
      mapping Image
      root_key plural: 'images', singular: 'image', scopes: [:read]
      root_key plural: 'snapshots', singular: 'snapshot', scopes: [:read_snapshot]
      root_key plural: 'backups', singular: 'backup', scopes: [:read_backup]

      property :id, scopes: [:read, :read_snapshot, :read_backup]
      property :name, scopes: [:read, :update, :read_snapshot, :read_backup]
      property :distribution, scopes: [:read, :read_snapshot, :read_backup]
      property :slug, scopes: [:read, :read_snapshot, :read_backup]
      property :public, scopes: [:read, :read_snapshot, :read_backup]
      property :regions, scopes: [:read, :read_snapshot, :read_backup]
      property :type, scopes: [:read, :read_snapshot, :read_backup]

      property :min_disk_size, scopes: [:read, :read_snapshot, :read_backup]
      property :created_at, scopes: [:read, :read_snapshot, :read_backup]
      property :size_gigabytes, scopes: [:read, :read_snapshot, :read_backup]
    end
  end
end
