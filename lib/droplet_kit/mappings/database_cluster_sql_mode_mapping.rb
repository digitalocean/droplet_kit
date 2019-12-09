module DropletKit
  class DatabaseClusterSQLModeMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterSQLMode
      scoped :read, :create do
        property :sql_mode
      end
    end
  end
end