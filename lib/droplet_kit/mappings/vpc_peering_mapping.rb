# frozen_string_literal: true

module DropletKit
  class VPCPeeringMapping
    include Kartograph::DSL

    kartograph do
      mapping VPCPeering
      root_key plural: 'vpc_peerings', singular: 'vpc_peering', scopes: [:read]

      scoped :read do
        property :id
        property :name
        property :vpc_ids
        property :created_at
        property :status
      end

      scoped :update, :patch do
        property :name
      end

      scoped :create do
        property :name
        property :vpc_ids
      end
    end
  end
end
