module DropletKit
  class DatabaseCluster < BaseModel
    attribute :id
    attribute :name
    attribute :engine
    attribute :version
    attribute :connection
    attribute :private_connection
    attribute :backup_restore
    attribute :users
    attribute :num_nodes
    attribute :size
    attribute :db_names
    attribute :region
    attribute :status
    attribute :maintenance_window
    attribute :created_at
    attribute :private_network_uuid
    attribute :tags
  end
end
