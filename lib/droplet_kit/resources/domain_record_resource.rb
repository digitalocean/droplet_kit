module DropletKit
  class DomainRecordResource < ResourceKit::Resource
    resources do
      action :all do
        path '/v2/domains/:name/records'
        verb :get
        handler(200) { |response| DomainRecordMapping.extract_collection(response.body, :read) }
      end
    end
  end
end