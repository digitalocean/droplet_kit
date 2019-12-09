module DropletKit
  class DatabaseClusterConnectionMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterConnection

      scoped :read do
        property :uri
        property :database
        property :host
        property :port
        property :user
        property :password
        property :ssl
      end
    end
  end
end