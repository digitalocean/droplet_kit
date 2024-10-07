# frozen_string_literal: true

module DropletKit
  class DatabaseMetricsCredentialsMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseMetricsCredentials
      root_key singular: 'credentials', scopes: %i[read update]

      property :basic_auth_username, scopes: %i[read update]
      property :basic_auth_password, scopes: %i[read update]
    end
  end
end
