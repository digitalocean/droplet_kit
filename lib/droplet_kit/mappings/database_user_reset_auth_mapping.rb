module DropletKit
  class DatabaseUserResetAuthMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseUserResetAuth
      scoped :create do
        property :mysql_settings do
          mapping DatabaseUserMySQLSettings
            property :auth_plugin, scopes: [:create]
        end
      end
    end
  end
end
