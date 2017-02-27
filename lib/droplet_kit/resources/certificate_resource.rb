module DropletKit
  class CertificateResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find, 'GET /v2/certificates/:id' do
        handler(200) { |response| CertificateMapping.extract_single(response.body, :read) }
      end

      action :all, 'GET /v2/certificates' do
        query_keys :per_page, :page
        handler(200) { |response| CertificateMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/certificates' do
        body { |certificate| CertificateMapping.representation_for(:create, certificate) }
        handler(201) { |response| CertificateMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete, 'DELETE /v2/certificates/:id' do
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
