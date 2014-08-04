module DropletKit
  class DomainRecordResource < ResourceKit::Resource
    resources do
      action :all do
        path '/v2/domains/:for_domain/records'
        verb :get
        handler(200) { |response| DomainRecordMapping.extract_collection(response.body, :read) }
      end

      action :create do
        path '/v2/domains/:for_domain/records'
        verb :post
        body {|object| DomainRecordMapping.representation_for(:create, object) }
        handler(201) { |response| DomainRecordMapping.extract_single(response.body, :read) }
      end

      action :find do
        path '/v2/domains/:for_domain/records/:id'
        verb :get
        handler(200) { |response| DomainRecordMapping.extract_single(response.body, :read) }
      end
    end
  end
end