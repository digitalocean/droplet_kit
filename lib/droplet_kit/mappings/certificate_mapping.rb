module DropletKit
  class CertificateMapping
    include Kartograph::DSL

    kartograph do
      mapping Certificate
      root_key singular: 'certificate', plural: 'certificates', scopes: [:read]

      scoped :read do
        property :id
        property :name
        property :dns_names
        property :not_after
        property :sha1_fingerprint
        property :created_at
        property :state
        property :type
      end

      scoped :create do
        property :name
        property :dns_names
        property :private_key
        property :leaf_certificate
        property :certificate_chain
        property :type
      end
    end
  end
end
