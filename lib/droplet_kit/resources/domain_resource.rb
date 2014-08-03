module DropletKit
  class DomainResource < ResourceKit::Resource
    resources do
      action :all do
        path '/v2/domains'
        verb :get
        handler(200) { |response| DomainMapping.extract_collection(response.body, :read) }
      end
    end
  end
end