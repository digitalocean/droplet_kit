module DropletKit
  class DatabaseConnectionPool < BaseModel
    attribute :name
    attribute :mode
    attribute :size
    attribute :db
    attribute :user
    attribute :connection
  end
end
