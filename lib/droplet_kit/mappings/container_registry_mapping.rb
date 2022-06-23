# frozen_string_literal: true

module DropletKit
  class ContainerRegistryMapping
    include Kartograph::DSL
    kartograph do
      mapping ContainerRegistry
      root_key singular: 'registry', scopes: [:read]

      property :name, scopes: %i[read create]
    end
  end
end
