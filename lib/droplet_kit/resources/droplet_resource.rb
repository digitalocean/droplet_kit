module DropletKit
  class DropletResource < ResourceKit::Resource
    resources do
      action :all do
        verb :get
        path '/v2/droplets'
        handler(200) { |response| DropletMapping.extract_collection(response.body, :read) }
      end

      action :find do
        verb :get
        path '/v2/droplets/:id'
        handler(200) { |response| DropletMapping.extract_single(response.body, :read) }
      end

      action :create do
        verb :post
        path '/v2/droplets'
        body { |object| DropletMapping.representation_for(:create, object) }
        handler(202) { |response| DropletMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete do
        verb :delete
        path '/v2/droplets/:id'
        handler(204) { |response| true }
      end

      action :kernels do
        verb :get
        path '/v2/droplets/:id/kernels'
        handler(200) { |response| KernelMapping.extract_collection(response.body, :read) }
      end

      action :snapshots do
        verb :get
        path '/v2/droplets/:id/snapshots'
        handler(200) { |response| SnapshotMapping.extract_collection(response.body, :read) }
      end

      action :backups do
        verb :get
        path '/v2/droplets/:id/backups'
        handler(200) { |response| BackupMapping.extract_collection(response.body, :read) }
      end

      action :actions do
        verb :get
        path '/v2/droplets/:id/actions'
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action_and_connection(:all), *args)
    end
  end
end