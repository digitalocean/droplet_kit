module DropletKit
  class NetworkMapping
    include Kartograph::DSL

    kartograph do
      mapping NetworkHash

      property :v4, plural: true, scopes: [:read], include: NetworkDetailMapping
      property :v6, plural: true, scopes: [:read], include: NetworkDetailMapping
    end
  end
end