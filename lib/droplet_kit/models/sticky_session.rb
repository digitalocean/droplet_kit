module DropletKit
  class StickySession < BaseModel
    attribute :type
    attribute :cookie_name
    attribute :cookie_ttl_seconds
  end
end
