module DropletKit
  class VPCMapping
    include Kartograph::DSL

    kartograph do
      mapping VPC
      root_key plural: 'vpcs', singular: 'vpc', scopes: [:read]

      scoped :read do
        property :id
        property :name
        property :region
        property :created_at
        property :default
      end

      scoped :update, :patch do
        property :name
      end

      scoped :create do
        property :name
        property :region
      end
    end
  end
end