# frozen_string_literal: true

module DropletKit
  class DatabaseSQLModeMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseSQLMode

      property :sql_mode, scopes: %i[read create]
    end
  end
end
