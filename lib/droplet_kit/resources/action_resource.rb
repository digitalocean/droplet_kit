module DropletKit
  class ActionResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/actions' do
        query_keys :per_page, :page
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/actions/:id' do
        handler(200) { |response| ActionMapping.extract_single(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end