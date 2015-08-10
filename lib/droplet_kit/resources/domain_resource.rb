module DropletKit
  class DomainResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/domains' do
        query_keys :per_page, :page
        handler(200) { |response| DomainMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/domains' do
        body { |object| DomainMapping.representation_for(:create, object) }
        handler(201) { |response| DomainMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/domains/:name' do
        handler(200) { |response| DomainMapping.extract_single(response.body, :read) }
      end

      action :delete, 'DELETE /v2/domains/:name' do
        handler(204) { |response| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
