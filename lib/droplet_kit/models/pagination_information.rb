module DropletKit
  class PaginationInformation < BaseModel
    include Kartograph::DSL

    Pages = Struct.new(:last, :next, :pref, :first)

    kartograph do
      mapping PaginationInformation
      root_key singular: 'links', scopes: [:read]

      property :pages do
        mapping Pages
        property :first, :prev, :next, :last, scopes: :read
      end
    end
  end
end