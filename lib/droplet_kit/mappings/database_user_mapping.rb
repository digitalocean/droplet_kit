module DropletKit
  class DatabaseUserMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseUser
      root_key singular: 'user', plural: 'users', scopes: [:read]

      property :name, scopes: [:read]
      property :role, scopes: [:read, :create]
      property :password, scopes: [:read, :create]
    end
  end
end
