module DropletKit
  class LinksMapping
    include Kartograph::DSL

    kartograph do
      mapping Links
      root_key plural: 'links', singular: 'links', scopes: [:read]

      property :myself, key: 'self', scopes: [:read]
      property :first, scopes: [:read]
      property :prev, scopes: [:read]
      property :next, scopes: [:read]
      property :last, scopes: [:read]
    end
  end
end
