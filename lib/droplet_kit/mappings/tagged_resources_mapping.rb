module DropletKit
  class TaggedResourcesMapping
    include Kartograph::DSL

    kartograph do
      mapping TaggedResources

      root_key plural: 'resources', singular: 'resource', scopes: [:read]

      scoped :read do
        property :droplets, include: TaggedDropletsResourcesMapping
      end
    end
  end
end
