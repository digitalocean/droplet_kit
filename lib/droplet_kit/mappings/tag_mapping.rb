module DropletKit
  class TagMapping
    include Kartograph::DSL

    kartograph do
      mapping Tag
      root_key plural: 'tags', singular: 'tag', scopes: [:read]

      scoped :read, :create, :update do
        property :name
      end

      scoped :read do
        property :resources, include: TaggedResourcesMapping
      end
    end
  end
end
