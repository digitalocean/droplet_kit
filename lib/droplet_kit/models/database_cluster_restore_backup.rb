module DropletKit
  class DatabaseClusterRestoreBackup < BaseModel
    attribute :name
    attribute :engine
    attribute :version
    attribute :region
    attribute :size
    attribute :num_nodes
    attribute :name
    attribute :backup_restore
  end

  class DatabaseClusterBackupRestore < BaseModel
    attribute :name
    attribute :created_at
  end
end