module DropletKit
  class LoadBalancer < BaseModel
    attribute :id
    attribute :ip
    attribute :name
    attribute :algorithm
    attribute :status
    attribute :created_at
    attribute :tag
    attribute :region
    attribute :redirect_http_to_https
    attribute :droplet_ids
    attribute :sticky_sessions
    attribute :health_check
    attribute :forwarding_rules
  end
end
