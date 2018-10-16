module DropletKit
  class Domain < BaseModel
    attribute :name
    attribute :ttl
    attribute :zone_file

    # Used for creates
    attribute :ip_address

    def identifier
      name
    end

    def self.from_identifier(identifier)
      new(name: identifier)
    end
  end
end