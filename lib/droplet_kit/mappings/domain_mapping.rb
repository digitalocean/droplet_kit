module DropletKit
  class DomainMapping
    include Kartograph::DSL

    kartograph do
      mapping Domain
      root_key plural: 'domains', singular: 'domain', scopes: [:read]

      property :name, scopes: [:read, :create]
      property :ttl, scopes: [:read]
      property :zone_file, scopes: [:read]
      property :ip_address, scopes: [:create]
    end
  end
end