module DropletKit
  class ImageActionResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      default_handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }

      action :transfer, 'POST /v2/images/:image_id/actions' do
        body { |object| { type: 'transfer', region: object[:region] }.to_json }
        handler(200, 201) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :convert, 'POST /v2/images/:image_id/actions' do
        body { |object| { type: 'convert' }.to_json }
        handler(200, 201) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :all, 'GET /v2/images/:image_id/actions' do
        query_keys :per_page, :page
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/images/:image_id/actions/:id' do
        handler(200) { |response| ActionMapping.extract_single(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
