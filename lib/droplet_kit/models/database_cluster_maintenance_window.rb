module DropletKit
  class DatabaseClusterMaintenanceWindow < BaseModel
    attribute :day
    attribute :hour
    attribute :pending
    attribute :description
  end
end