# frozen_string_literal: true

module DropletKit
  class DatabaseMapping
    include Kartograph::DSL

    kartograph do
      mapping Database
      root_key singular: 'db', plural: 'dbs', scopes: [:read]

      property :name, scopes: %i[read create]
    end
  end
end
