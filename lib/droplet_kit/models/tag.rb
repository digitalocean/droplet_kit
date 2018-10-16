module DropletKit
  class Tag < BaseModel
    attribute :name
    attribute :resources

    def identifier
      name
    end

    def self.from_identifier(identifier)
      new(name: identifier)
    end
  end
end
