# frozen_string_literal: true

module DropletKit
  class DatabaseMaintenanceWindow < BaseModel
    attribute :day
    attribute :hour
    attribute :pending
    attribute :description
  end
end
