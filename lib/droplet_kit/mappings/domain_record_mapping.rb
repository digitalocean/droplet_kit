# frozen_string_literal: true

module DropletKit
  class DomainRecordMapping
    include Kartograph::DSL

    kartograph do
      mapping DomainRecord
      root_key plural: 'domain_records', singular: 'domain_record', scopes: [:read]

      property :id, scopes: [:read]
      property :type, scopes: %i[read create update]
      property :name, scopes: %i[read create update]
      property :data, scopes: %i[read create update]
      property :priority, scopes: %i[read create update]
      property :port, scopes: %i[read create update]
      property :ttl, scopes: %i[read create update]
      property :weight, scopes: %i[read create update]
      property :flags, scopes: %i[read create update]
      property :tag, scopes: %i[read create update]
    end
  end
end
