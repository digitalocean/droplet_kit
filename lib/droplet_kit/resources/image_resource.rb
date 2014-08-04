module DropletKit
  class ImageResource < ResourceKit::Resource
    resources do
      action :all do
        verb :get
        path '/v2/images'
        handler(200) { |response| ImageMapping.extract_collection(response.body, :read) }
      end

      action :find do
        verb :get
        path '/v2/images/:id'
        handler(200) { |response| ImageMapping.extract_single(response.body, :read) }
      end

      action :delete do
        verb :delete
        path '/v2/images/:id'
        handler(204) { |response| true }
      end

      action :update do
        verb :put
        path '/v2/images/:id'
        body {|image| ImageMapping.representation_for(:update, image) }
        handler(200) { |response| ImageMapping.extract_single(response.body, :read) }
      end
    end
  end
end