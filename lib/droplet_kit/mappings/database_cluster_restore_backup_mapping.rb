module DropletKit
  class DatabaseClusterRestoreBackupMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterRestoreBackup

      scoped :create do
        property :name
        property :engine
        property :version
        property :region
        property :size
        property :num_nodes
        property :name
        property :backup_restore do
          mapping DatabaseClusterBackupRestore
          
          property :name
          property :created_at
        end
      end
    end
  end
end