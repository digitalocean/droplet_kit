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
      end
    end
  end
end