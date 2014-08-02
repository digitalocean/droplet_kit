module DropletKit
  class DropletResource < ResourceKit::Resource
    resources do
      action :all do
        verb :get
        path '/v2/droplets'
        handler(200) { |response| DropletMapping.extract_collection(response.body, :read) }
      end
    end
  end
end