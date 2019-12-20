module DropletKit
  class DatabaseConnectionMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseConnection
      root_key singular: 'connection', plural: 'connections', scopes: [:read]

      property :uri, scopes: [:read]
      property :database, scopes: [:read]
      property :host, scopes: [:read]
      property :port, scopes: [:read]
      property :user, scopes: [:read]
      property :password, scopes: [:read]
      property :ssl, scopes: [:read]
    end
  end
end
