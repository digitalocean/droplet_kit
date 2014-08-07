module DropletKit
  class ActionResource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/actions' do
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/actions/:id' do
        handler(200) { |response| ActionMapping.extract_single(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action_and_connection(:all), *args)
    end
  end
end