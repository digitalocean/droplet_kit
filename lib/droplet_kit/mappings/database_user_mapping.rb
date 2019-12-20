module DropletKit
  class DatabaseUserMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseUser
      root_key singular: 'database_user', plural: 'database_users', scopes: [:read]

      property :name, scopes: [:read]
      property :role, scopes: [:read, :create, :update]
      property :password, scopes: [:read, :create, :update]
    end
  end
end
