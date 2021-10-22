# frozen_string_literal: true

module DropletKit
  class VPCMapping
    include Kartograph::DSL

    kartograph do
      mapping VPC
      root_key plural: 'vpcs', singular: 'vpc', scopes: [:read]

      scoped :read do
        property :id
        property :urn
        property :name
        property :description
        property :ip_range
        property :region
        property :created_at
        property :default
      end

      scoped :update, :patch do
        property :name
        property :description
        property :default
      end

      scoped :create do
        property :name
        property :description
        property :region
        property :ip_range
      end
    end
  end
end
