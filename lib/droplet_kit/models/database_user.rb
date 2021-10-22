# frozen_string_literal: true

module DropletKit
  class DatabaseUser < BaseModel
    attribute :name
    attribute :role
    attribute :password
  end
end
