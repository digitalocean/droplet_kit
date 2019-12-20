module DropletKit
  class DatabaseConnection < BaseModel
    attribute :uri
    attribute :database
    attribute :host
    attribute :port
    attribute :user
    attribute :password
    attribute :ssl
  end
end
