module DropletKit
  class DomainRecordResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/domains/:for_domain/records' do
        query_keys :per_page, :page
        handler(200) { |response| DomainRecordMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/domains/:for_domain/records' do
        body {|object| DomainRecordMapping.representation_for(:create, object) }
        handler(201) { |response| DomainRecordMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/domains/:for_domain/records/:id' do
        handler(200) { |response| DomainRecordMapping.extract_single(response.body, :read) }
      end

      action :delete, 'DELETE /v2/domains/:for_domain/records/:id' do
        handler(204) { |response| true }
      end

      action :update, 'PUT /v2/domains/:for_domain/records/:id' do
        body {|object| DomainRecordMapping.representation_for(:update, object) }
        handler(200) { |response| DomainRecordMapping.extract_single(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
