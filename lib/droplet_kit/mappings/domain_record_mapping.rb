module DropletKit
  class DomainRecordMapping
    include Kartograph::DSL

    kartograph do
      mapping DomainRecord
      root_key plural: 'domain_records', singular: 'domain_record', scopes: [:read]

      property :id, scopes: [:read]
      property :type, scopes: [:read, :create, :update]
      property :name, scopes: [:read, :create, :update]
      property :data, scopes: [:read, :create, :update]
      property :priority, scopes: [:read, :create, :update]
      property :port, scopes: [:read, :create, :update]
      property :ttl, scopes: [:read, :create, :update]
      property :weight, scopes: [:read, :create, :update]
      property :flags, scopes: [:read, :create, :update]
      property :tag, scopes: [:read, :create, :update]
    end
  end
end
