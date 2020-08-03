module DropletKit
  class DatabaseConnectionPoolMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseConnectionPool
      root_key singular: 'pool', plural: 'pools', scopes: [:read]

      property :name, scopes: [:read, :create]
      property :mode, scopes: [:read, :create]
      property :size, scopes: [:read, :create]
      property :db, scopes: [:read, :create]
      property :user, scopes: [:read, :create]
      property :connection, scopes: [:read], include: DatabaseConnectionMapping
    end
  end
end
