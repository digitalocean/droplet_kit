module DropletKit
  class DropletResource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/droplets' do
        query_keys :per_page, :page
        handler(200) { |response| DropletMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/droplets/:id' do
        handler(200) { |response| DropletMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/droplets' do
        body { |object| DropletMapping.representation_for(:create, object) }
        handler(202) { |response| DropletMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete, 'DELETE /v2/droplets/:id' do
        handler(204) { |response| true }
      end

      action :kernels, 'GET /v2/droplets/:id/kernels' do
        handler(200) { |response| KernelMapping.extract_collection(response.body, :read) }
      end

      action :snapshots, 'GET /v2/droplets/:id/snapshots' do
        handler(200) { |response| SnapshotMapping.extract_collection(response.body, :read) }
      end

      action :backups, 'GET /v2/droplets/:id/backups' do
        handler(200) { |response| BackupMapping.extract_collection(response.body, :read) }
      end

      action :actions, 'GET /v2/droplets/:id/actions' do
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action_and_connection(:all), *args)
    end
  end
end