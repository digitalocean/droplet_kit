module DropletKit
  class SizeResource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/sizes' do
        handler(200) { |r| SizeMapping.extract_collection(r.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action_and_connection(:all), *args)
    end
  end
end