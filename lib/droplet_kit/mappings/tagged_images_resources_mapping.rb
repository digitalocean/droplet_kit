module DropletKit
  class TaggedImagesResourcesMapping
    include Kartograph::DSL

    kartograph do
      mapping TaggedImagesResources

      root_key plural: 'images', singular: 'image', scopes: [:read]

      scoped :read do
        property :count
        property :last_tagged_uri
      end
    end
  end
end
