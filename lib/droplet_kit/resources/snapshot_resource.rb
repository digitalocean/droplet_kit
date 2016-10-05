module DropletKit
  class SnapshotResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/snapshots' do
        query_keys :page, :per_page, :resource_type
        handler(200) { |response| SnapshotMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/snapshots/:id' do
        handler(200) { |response| SnapshotMapping.extract_single(response.body, :read) }
      end

      action :delete, 'DELETE /v2/snapshots/:id' do
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end