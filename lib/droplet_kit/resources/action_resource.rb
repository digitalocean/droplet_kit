module DropletKit
  class ActionResource < ResourceKit::Resource
    resources do
      action :all do
        path '/v2/actions'
        verb :get
        handler(200) { |response| ActionMapping.extract_collection(response.body, :read) }
      end
    end
  end
end