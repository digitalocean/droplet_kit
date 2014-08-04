module DropletKit
  class DomainRecordMapping
    include Kartograph::DSL

    kartograph do
      mapping DomainRecord
      root_key plural: 'domain_records', singular: 'domain_record', scopes: [:read]

      property :id, scopes: [:read]
      property :type, scopes: [:read, :create]
      property :name, scopes: [:read, :create]
      property :data, scopes: [:read, :create]
      property :priority, scopes: [:read, :create]
      property :port, scopes: [:read, :create]
      property :weight, scopes: [:read, :create]
    end
  end
end