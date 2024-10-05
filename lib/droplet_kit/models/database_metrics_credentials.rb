# frozen_string_literal: true

module DropletKit
  class DatabaseMetricsCredentials < BaseModel
    attribute :basic_auth_username
    attribute :basic_auth_password
  end
end
