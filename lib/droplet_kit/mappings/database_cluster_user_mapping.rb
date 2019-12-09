module DropletKit
  class DatabaseClusterUserMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterUser

      scoped :read, :create do
        property :name
      end

      scoped :read do
        property :role
        property :password
      end
    end
  end
end