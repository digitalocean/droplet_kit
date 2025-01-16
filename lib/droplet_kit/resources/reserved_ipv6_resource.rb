# frozen_string_literal: true
module DropletKit
  class ReservedIpv6Resource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/reserved_ipv6' do
        query_keys :per_page, :page
        handler(200) { |response| ReservedIpv6Mapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/reserved_ipv6/:ip' do
        handler(200) { |response| ReservedIpv6Mapping.extract_single(response.body, :read) }
        handler(404)  { |response| ErrorMapping.fail_with(Error, response.body) }
      end

      action :create, 'POST /v2/reserved_ipv6' do
        body { |object| ReservedIpv6Mapping.representation_for(:create, object) }
        handler(201) { |response| ReservedIpv6Mapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete, 'DELETE /v2/reserved_ipv6/:ip' do
        handler(404)  { |response| ErrorMapping.fail_with(FailedDelete, response.body) }
        handler(202) { |response| ActionMapping.extract_single(response.body, :read) }
        handler(204) { |response| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
