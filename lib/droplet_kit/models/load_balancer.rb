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
    attribute :redirect_http_to_https, Boolean, :default => false
    attribute :enable_proxy_protocol, Boolean, :default => false
    attribute :droplet_ids
    attribute :sticky_sessions, StickySession
    attribute :health_check
    attribute :forwarding_rules
    attribute :vpc_uuid
  end
end
