module DropletKit
  class Certificate < BaseModel
    attribute :id
    attribute :name
    attribute :dns_names
    attribute :not_after
    attribute :sha1_fingerprint
    attribute :created_at
    attribute :private_key
    attribute :leaf_certificate
    attribute :certificate_chain
    attribute :type
    attribute :state
  end
end
