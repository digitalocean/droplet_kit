module DropletKit
  class DatabaseSQLModeMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseSQLMode

      property :sql_mode, scopes: [:read, :create]
    end
  end
end
