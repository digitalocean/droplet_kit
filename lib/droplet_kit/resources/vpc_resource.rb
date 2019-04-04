module DropletKit
  class VPCResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find, 'GET /v2/vpcs/:id' do
        handler(200) do |response|
          VPCMapping.extract_single(response.body, :read)
        end
      end

      action :all, 'GET /v2/vpcs' do
        query_keys :per_page, :page

        handler(200) do |response|
          VPCMapping.extract_collection(response.body, :read)
        end
      end

      action :create, 'POST /v2/vpcs' do
        body { |vpc| VPCMapping.representation_for(:create, vpc) }
        handler(202) { |response| VPCMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update, 'PUT /v2/vpcs/:id' do
        body {|vpc| VPCMapping.representation_for(:update, vpc) }
        handler(200) { |response| VPCMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :patch, 'PATCH /v2/vpcs/:id' do
          body {|vpc| VPCMapping.representation_for(:patch, vpc) }
          handler(200) { |response| VPCMapping.extract_single(response.body, :read) }
          handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
        end

      action :delete, 'DELETE /v2/vpcs/:id' do
        handler(204) { |_| true }
      end

      action :all_members, 'GET /v2/vpcs/:id/members' do
        query_keys :per_page, :page
        handler(200) { |response| VPCMemberMapping.extract_collection(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end

    def all_members(*args)
      PaginatedResource.new(action(:all_members), self, *args)
    end
  end
end
