module DropletKit
  class DatabaseBackup < BaseModel
    attribute :created_at
    attribute :size_gigabytes
    attribute :database_name
    attribute :backup_created_at
  end
end
