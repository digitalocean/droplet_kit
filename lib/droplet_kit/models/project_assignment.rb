module DropletKit
  class ProjectAssignment < BaseModel
    attribute :urn
    attribute :assigned_at
    attribute :links

    def self_link
      links.try(:myself)
    end

    def to_model
      BaseModel.from_urn(urn)
    end
  end
end
