module DropletKit
  class TagMapping
    include Kartograph::DSL

    kartograph do
      mapping Tag
      root_key plural: 'tags', singular: 'tag', scopes: [:read]

      scoped :read, :create, :update do
        property :name
      end
    end
  end
end
