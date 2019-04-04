module DropletKit
  class LoadBalancerMapping
    include Kartograph::DSL

    kartograph do
      mapping LoadBalancer
      root_key singular: 'load_balancer', plural: 'load_balancers', scopes: [:read]

      scoped :read do
        property :id
        property :ip
        property :status
        property :created_at
        property :region, include: RegionMapping
        property :vpc_uuid
      end

      scoped :read, :update, :create do
        property :name
        property :algorithm
        property :tag
        property :redirect_http_to_https
        property :enable_proxy_protocol
        property :droplet_ids
        property :sticky_sessions, include: StickySessionMapping
        property :health_check, include: HealthCheckMapping
        property :forwarding_rules, plural: true, include: ForwardingRuleMapping
      end

      scoped  :update, :create do
        property :region
      end

      scoped :create do
        property :vpc_uuid
      end
    end
  end
end
