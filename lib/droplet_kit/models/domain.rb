module DropletKit
  class Domain < BaseModel
    attribute :name
    attribute :ttl
    attribute :zone_file

    # Used for creates
    attribute :ip_address
  end
end