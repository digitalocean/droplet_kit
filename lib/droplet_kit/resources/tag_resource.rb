module DropletKit
  class TagResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/tags' do
        query_keys :per_page, :page
        handler(200) { |response| TagMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/tags/:name' do
        handler(200) { |response| TagMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/tags' do
        body { |object| TagMapping.representation_for(:create, object) }
        handler(201) { |response| TagMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete, 'DELETE /v2/tags/:name' do
        handler(204) { |_| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :tag_resources, 'POST /v2/tags/:name/resources' do
        verb :post
        body do |hash|
          resources = hash[:resources].map do |resource|
            resource[:resource_id] = resource[:resource_id].to_s
            resource
          end

          { resources: resources }.to_json
        end
        handler(204) { |_| true }
      end

      action :untag_resources, 'DELETE /v2/tags/:name/resources' do
        verb :delete
        body do |hash|
          resources = hash[:resources].map do |resource|
            resource[:resource_id] = resource[:resource_id].to_s
            resource
          end

          { resources: resources }.to_json
        end
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
