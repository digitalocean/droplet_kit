module DropletKit
  class DatabaseClusterConnectionPool < BaseModel
    attribute :name
    attribute :mode
    attribute :size
    attribute :db
    attribute :user
    attribute :connection
  end
end