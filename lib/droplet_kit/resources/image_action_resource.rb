module DropletKit
  class ImageActionResource < ResourceKit::Resource
    resources do
      action :transfer, 'POST /v2/images/:image_id/actions' do
        body { |object| { type: 'transfer', region: object[:region] }.to_json }
        handler(200, 201) { |response| ImageActionMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/images/:image_id/actions/:id' do
        handler(200) { |response| ImageActionMapping.extract_single(response.body, :read) }
      end
    end
  end
end