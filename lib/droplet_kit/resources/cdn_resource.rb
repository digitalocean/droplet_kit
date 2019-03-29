module DropletKit
  class CDNResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find, 'GET /v2/cdn/endpoints/:id' do
        handler(200) { |response| CDNMapping.extract_single(response.body, :read) }
      end

      action :all, 'GET /v2/cdn/endpoints' do
        query_keys :per_page, :page
        handler(200) { |response| CDNMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/cdn/endpoints' do
        body { |cdn| CDNMapping.representation_for(:create, cdn) }
        handler(201) { |response| CDNMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update_ttl, 'PUT /v2/cdn/endpoints/:id' do
        body { |hash| { ttl: hash[:ttl] }.to_json }
        handler(200) { |response| CDNMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :update_custom_domain, 'PUT /v2/cdn/endpoints/:id' do
        body { |hash| { custom_domain: hash[:custom_domain].to_s, certificate_id: hash[:certificate_id].to_s }.to_json }
        handler(200) { |response| CDNMapping.extract_single(response.body, :read) }
        handler(409, 412, 422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :flush_cache, 'DELETE /v2/cdn/endpoints/:id/cache' do
        body { |hash| { files: hash[:files] }.to_json }
        handler(204) { |_| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :delete, 'DELETE /v2/cdn/endpoints/:id' do
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
