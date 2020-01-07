module DropletKit
  class DatabaseClusterConnectionPoolMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterConnectionPool
      root_key singular: 'pool', plural: 'pools', scopes: [:read]
    
      scoped :read, :create do
        property :name
        property :mode
        property :size
        property :db
        property :user
      end

      scoped :read do
        property :connection, include: DatabaseClusterConnectionMapping
      end
    end
  end
end