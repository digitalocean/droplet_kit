# frozen_string_literal: true

module DropletKit
  class DatabaseUserMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseUser
      root_key singular: 'user', plural: 'users', scopes: [:read]

      property :name, scopes: %i[read create]
      property :role, scopes: %i[read create]
      property :password, scopes: %i[read create]
    end
  end
end
