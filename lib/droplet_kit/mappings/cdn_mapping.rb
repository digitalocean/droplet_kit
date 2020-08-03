module DropletKit
  class CDNMapping
    include Kartograph::DSL

    kartograph do
      mapping CDN
      root_key singular: 'endpoint', plural: 'endpoints', scopes: [:read]

      scoped :read do
        property :id
        property :ttl
        property :custom_domain
        property :certificate_id
        property :origin
        property :endpoint
        property :created_at
      end

      scoped :create do
        property :origin
        property :ttl
        property :custom_domain
        property :certificate_id
      end

      scoped :update do
        property :ttl
        property :custom_domain
        property :certificate_id
      end

      scoped :delete_cache do
        property :files
      end
    end
  end
end
