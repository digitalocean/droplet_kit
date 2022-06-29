# frozen_string_literal: true

module DropletKit
  class ImageMapping
    include Kartograph::DSL

    kartograph do
      mapping Image
      root_key plural: 'images', singular: 'image', scopes: [:read]
      root_key plural: 'snapshots', singular: 'snapshot', scopes: [:read_snapshot]
      root_key plural: 'backups', singular: 'backup', scopes: [:read_backup]

      property :id, scopes: %i[read read_snapshot read_backup]
      property :name, scopes: %i[read update read_snapshot read_backup]
      property :distribution, scopes: %i[read read_snapshot read_backup]
      property :slug, scopes: %i[read read_snapshot read_backup]
      property :public, scopes: %i[read read_snapshot read_backup]
      property :regions, scopes: %i[read read_snapshot read_backup]
      property :type, scopes: %i[read read_snapshot read_backup]

      property :min_disk_size, scopes: %i[read read_snapshot read_backup]
      property :created_at, scopes: %i[read read_snapshot read_backup]
      property :size_gigabytes, scopes: %i[read read_snapshot read_backup]
    end
  end
end
