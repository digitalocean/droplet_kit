module DropletKit
  class StickySessionMapping
    include Kartograph::DSL

    kartograph do
      mapping StickySession

      scoped :read, :create, :update do
        property :type
        property :cookie_name
        property :cookie_ttl_seconds
      end
    end
  end
end
