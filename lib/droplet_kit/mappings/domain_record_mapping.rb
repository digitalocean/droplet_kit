module DropletKit
  class DomainRecordMapping
    include Kartograph::DSL

    kartograph do
      mapping DomainRecord
      root_key plural: 'domain_records', singular: 'domain_record', scopes: [:read]

      property :id, scopes: [:read]
      property :type, scopes: [:read]
      property :name, scopes: [:read]
      property :data, scopes: [:read]
      property :priority, scopes: [:read]
      property :port, scopes: [:read]
      property :weight, scopes: [:read]
    end
  end
end