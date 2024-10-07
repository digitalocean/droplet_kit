# frozen_string_literal: true

module DropletKit
  class DatabaseConnectionPoolMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseConnectionPool
      root_key singular: 'pool', plural: 'pools', scopes: [:read]

      property :name, scopes: %i[read create]
      property :mode, scopes: %i[read create update]
      property :size, scopes: %i[read create update]
      property :db, scopes: %i[read create update]
      property :user, scopes: %i[read create update]
      property :connection, scopes: [:read], include: DatabaseConnectionMapping
    end
  end
end
