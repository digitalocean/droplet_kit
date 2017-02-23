module DropletKit
  class CertificateMapping
    include Kartograph::DSL

    kartograph do
      mapping Certificate
      root_key singular: 'certificate', plural: 'certificates', scopes: [:read]

      scoped :read do
        property :id
        property :name
        property :not_after
        property :sha1_fingerprint
        property :created_at
      end

      scoped :create do
        property :name
        property :private_key
        property :leaf_certificate
        property :certificate_chain
      end
    end
  end
end
