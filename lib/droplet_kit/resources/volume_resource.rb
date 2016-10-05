module DropletKit
  class VolumeResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/volumes' do
        query_keys :per_page, :page
        handler(200) { |response| VolumeMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/volumes' do
        body { |object| VolumeMapping.representation_for(:create, object) }
        handler(201) { |response| VolumeMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :find, 'GET /v2/volumes/:id' do
        handler(200) { |response| VolumeMapping.extract_single(response.body, :read) }
      end

      action :delete, 'DELETE /v2/volumes/:id' do
        handler(204) { |response| true }
      end

      action :snapshots, 'GET /v2/volumes/:id/snapshots' do
        query_keys :per_page, :page
        handler(200) { |response| SnapshotMapping.extract_collection(response.body, :read) }
      end

      action :create_snapshot, 'POST /v2/volumes/:id/snapshots' do
        body { |hash| { name: hash[:name] }.to_json }
        handler(201) { |response| SnapshotMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end

    def snapshots(*args)
      PaginatedResource.new(action(:snapshots), self, *args)
    end
  end
end
