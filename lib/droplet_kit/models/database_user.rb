module DropletKit
  class DatabaseUser < BaseModel
    attribute :name
    attribute :role
    attribute :password
  end
end