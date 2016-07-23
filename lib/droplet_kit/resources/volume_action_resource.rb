module DropletKit
  class VolumeActionResource < ResourceKit::Resource
    resources do
      default_handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }

      action :attach, 'POST /v2/volumes/:volume_id/actions' do
        body do |hash|
          {
            type: 'attach',
            droplet_id: hash[:droplet_id],
            volume_id: hash[:volume_id], # seems redundant to the id in the url?
            region: hash[:region], # seems redundant - inferred from the droplet?
          }.to_json
        end
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :detach, 'POST /v2/volumes/:volume_id/actions' do
        body do |hash|
          {
            type: 'detach',
            droplet_id: hash[:droplet_id],
            volume_id: hash[:volume_id], # seems redundant to the id in the url?
            region: hash[:region], # seems redundant - inferred from the droplet?
          }.to_json
        end
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :resize, 'POST /v2/volumes/:volume_id/actions' do
        body do |hash|
          {
            type: 'resize',
            size_gigabytes: hash[:size_gigabytes],
            region: hash[:region],
          }.to_json
        end
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/volumes/:volume_id/actions/:id' do
        handler(200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :all, 'GET /v2/volumes/:volume_id/actions' do
        query_keys :per_page, :page
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end