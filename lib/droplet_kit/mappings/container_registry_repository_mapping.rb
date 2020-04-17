module DropletKit
  class ContainerRegistryRepositoryMapping
    include Kartograph::DSL
    kartograph do
      mapping ContainerRegistryRepository
      root_key singular: 'repository', plural: 'repositories', scopes: [:read]

      property :registry_name, scopes: [:read]
      property :name, scopes: [:read]
      property :latest_tag, scopes: [:read], include: ContainerRegistryRepositoryTagMapping
    end
  end
end
