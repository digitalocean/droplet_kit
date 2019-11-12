module DropletKit
  class ContainerRegistryMapping
    include Kartograph::DSL
    kartograph do
      mapping ContainerRegistry
      root_key singular: 'registry', scopes: [:read]

      property :name, scopes: [:read, :create]
    end
  end
end
