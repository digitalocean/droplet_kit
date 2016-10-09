module DropletKit
  class DropletResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/droplets' do
        query_keys :per_page, :page, :tag_name
        handler(200) { |response| DropletMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/droplets/:id' do
        handler(200) { |response| DropletMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/droplets' do
        body { |object| DropletMapping.representation_for(:create, object) }
        handler(202) { |response, droplet| DropletMapping.extract_into_object(droplet, response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :create_multiple, 'POST /v2/droplets' do
        body { |object| DropletMapping.representation_for(:create, object) }
        handler(202) { |response| DropletMapping.extract_collection(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete, 'DELETE /v2/droplets/:id' do
        handler(204) { |response| true }
      end

      action :kernels, 'GET /v2/droplets/:id/kernels' do
        query_keys :per_page, :page
        handler(200) { |response| KernelMapping.extract_collection(response.body, :read) }
      end

      action :snapshots, 'GET /v2/droplets/:id/snapshots' do
        query_keys :per_page, :page
        handler(200) { |response| ImageMapping.extract_collection(response.body, :read_snapshot) }
      end

      action :backups, 'GET /v2/droplets/:id/backups' do
        query_keys :per_page, :page
        handler(200) { |response| ImageMapping.extract_collection(response.body, :read_backup) }
      end

      action :actions, 'GET /v2/droplets/:id/actions' do
        query_keys :per_page, :page
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end

      action :delete_for_tag, 'DELETE /v2/droplets' do
        verb :delete
        query_keys :tag_name
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end

    def kernels(*args)
      PaginatedResource.new(action(:kernels), self, *args)
    end

    def snapshots(*args)
      PaginatedResource.new(action(:snapshots), self, *args)
    end

    def backups(*args)
      PaginatedResource.new(action(:backups), self, *args)
    end

    def actions(*args)
      PaginatedResource.new(action(:actions), self, *args)
    end
  end
end
