module DropletKit
  class MetaInformation < BaseModel
    include Kartograph::DSL

    kartograph do
      mapping MetaInformation
      root_key singular: 'meta', scopes: [:read]

      property :total, scopes: [:read]
    end

    attribute :total
  end
end