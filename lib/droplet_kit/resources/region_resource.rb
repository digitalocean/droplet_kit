module DropletKit
  class RegionResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/regions' do
        query_keys :per_page, :page
        handler(200) { |r| RegionMapping.extract_collection(r.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
