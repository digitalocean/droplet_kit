module DropletKit
  class CDN < BaseModel
    attribute :id
    attribute :ttl
    attribute :origin
    attribute :endpoint
    attribute :created_at
    attribute :custom_domain
    attribute :certificate_id
  end
end
