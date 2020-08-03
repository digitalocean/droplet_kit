module DropletKit
  class StickySession < BaseModel
    attribute :type, String
    attribute :cookie_name, String
    attribute :cookie_ttl_seconds, Integer
  end
end
