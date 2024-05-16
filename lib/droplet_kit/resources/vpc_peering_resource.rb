# frozen_string_literal: true

module DropletKit
  class VPCPeeringResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find, 'GET /v2/vpc_peerings/:id' do
        handler(200) do |response|
          VPCPeeringMapping.extract_single(response.body, :read)
        end
      end

      action :all, 'GET /v2/vpc_peerings' do
        query_keys :per_page, :page

        handler(200) do |response|
          VPCPeeringMapping.extract_collection(response.body, :read)
        end
      end

      action :create, 'POST /v2/vpc_peerings' do
        body { |vpc| VPCPeeringMapping.representation_for(:create, vpc) }
        handler(202) { |response| VPCPeeringMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update, 'PUT /v2/vpc_peerings/:id' do
        body { |vpc| VPCPeeringMapping.representation_for(:update, vpc) }
        handler(200) { |response| VPCPeeringMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :patch, 'PATCH /v2/vpc_peerings/:id' do
        body { |vpc| VPCPeeringMapping.representation_for(:patch, vpc) }
        handler(200) { |response| VPCPeeringMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :delete, 'DELETE /v2/vpc_peerings/:id' do
        handler(202) { |response| VPCPeeringMapping.extract_single(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
