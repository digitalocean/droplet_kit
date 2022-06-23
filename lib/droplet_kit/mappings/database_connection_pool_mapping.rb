# frozen_string_literal: true

module DropletKit
  class DatabaseConnectionPoolMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseConnectionPool
      root_key singular: 'pool', plural: 'pools', scopes: [:read]

      property :name, scopes: %i[read create]
      property :mode, scopes: %i[read create]
      property :size, scopes: %i[read create]
      property :db, scopes: %i[read create]
      property :user, scopes: %i[read create]
      property :connection, scopes: [:read], include: DatabaseConnectionMapping
    end
  end
end
