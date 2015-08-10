module DropletKit
  class SizeResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/sizes' do
        query_keys :per_page, :page
        handler(200) { |r| SizeMapping.extract_collection(r.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
