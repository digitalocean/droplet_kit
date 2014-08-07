module DropletKit
  class RegionResource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/regions' do
        handler(200) { |r| RegionMapping.extract_collection(r.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action_and_connection(:all), *args)
    end
  end
end