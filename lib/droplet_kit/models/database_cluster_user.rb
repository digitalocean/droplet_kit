module DropletKit
  class DatabaseClusterUser < BaseModel
    attribute :name
    attribute :role
    attribute :password
  end
end