module DropletKit
  class TaggedResourcesMapping
    include Kartograph::DSL

    kartograph do
      mapping TaggedResources

      root_key plural: 'resources', singular: 'resource', scopes: [:read]

      scoped :read do
        property :count
        property :last_tagged_uri
        property :droplets, include: TaggedDropletsResourcesMapping
        property :images, include: TaggedImagesResourcesMapping
      end
    end
  end
end
