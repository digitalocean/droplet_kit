# frozen_string_literal: true

module DropletKit
  class ContainerRegistryRepositoryTagMapping
    include Kartograph::DSL
    kartograph do
      mapping ContainerRegistryRepositoryTag
      root_key singular: 'tag', plural: 'tags', scopes: [:read]

      property :registry_name, scopes: [:read]
      property :repository, scopes: [:read]
      property :tag, scopes: [:read]
      property :manifest_digest, scopes: [:read]
      property :compressed_size_bytes, scopes: [:read]
      property :size_bytes, scopes: [:read]
      property :updated_at, scopes: [:read]
    end
  end
end
