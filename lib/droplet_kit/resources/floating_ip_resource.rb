module DropletKit
  class FloatingIpResource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/floating_ips' do
        query_keys :per_page, :page
        handler(200) { |response| FloatingIpMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/floating_ips/:ip' do
        handler(200) { |response| FloatingIpMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/floating_ips' do
        body { |object| FloatingIpMapping.representation_for(:create, object) }
        handler(202) { |response| FloatingIpMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete, 'DELETE /v2/floating_ips/:ip' do
        handler(202) { |response| ActionMapping.extract_single(response.body, :read) }
        handler(204) { |response| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end