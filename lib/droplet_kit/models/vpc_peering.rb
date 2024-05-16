# frozen_string_literal: true

module DropletKit
  class VPCPeering < BaseModel
    attribute :id
    attribute :name
    attribute :vpc_ids
    attribute :created_at
    attribute :status
  end
end
