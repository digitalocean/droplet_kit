module DropletKit
  class TaggedDropletsResourcesMapping
    include Kartograph::DSL

    kartograph do
      mapping TaggedDropletsResources

      root_key plural: 'droplets', singular: 'droplet', scopes: [:read]

      scoped :read do
        property :count
        property :last_tagged_uri
        property :last_tagged, include: DropletMapping
      end
    end
  end
end
