# frozen_string_literal: true

module DropletKit
  class OneClickMapping
    include Kartograph::DSL

    kartograph do
      mapping OneClick
      root_key plural: '1_clicks', scopes: [:read]

      scoped :read do
        property :slug
        property :type
      end
    end
  end
end
