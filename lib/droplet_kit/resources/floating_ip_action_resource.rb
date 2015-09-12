module DropletKit
  class FloatingIpActionResource < ResourceKit::Resource
    resources do
      default_handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }

      action :assign, 'POST /v2/floating_ips/:ip/actions' do
        body { |hash| { type: 'assign', droplet_id: hash[:droplet_id] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :unassign, 'POST /v2/floating_ips/:ip/actions' do
        body { |hash| { type: 'unassign' }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/floating_ips/:ip/actions/:id' do
        handler(200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :all, 'GET /v2/floating_ips/:ip/actions' do
        query_keys :per_page, :page
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end