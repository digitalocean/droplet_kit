require 'droplet_kit/version'
require 'active_support/all'
require 'resource_kit'
require 'kartograph'

module DropletKit
  autoload :Client, 'droplet_kit/client'

  # Models
  autoload :BaseModel, 'droplet_kit/models/base_model'
  autoload :Droplet, 'droplet_kit/models/droplet'
  autoload :Region, 'droplet_kit/models/region'
  autoload :Image, 'droplet_kit/models/image'
  autoload :Size, 'droplet_kit/models/size'
  autoload :NetworkHash, 'droplet_kit/models/network_hash'
  autoload :Network, 'droplet_kit/models/network'
  autoload :Kernel, 'droplet_kit/models/kernel'
  autoload :Snapshot, 'droplet_kit/models/snapshot'
  autoload :Action, 'droplet_kit/models/action'
  autoload :Domain, 'droplet_kit/models/domain'
  autoload :DomainRecord, 'droplet_kit/models/domain_record'
  autoload :SSHKey, 'droplet_kit/models/ssh_key'
  autoload :MetaInformation, 'droplet_kit/models/meta_information'
  autoload :Account, 'droplet_kit/models/account'
  autoload :DropletUpgrade, 'droplet_kit/models/droplet_upgrade'
  autoload :FloatingIp, 'droplet_kit/models/floating_ip'
  autoload :Tag, 'droplet_kit/models/tag'
  autoload :TaggedResources, 'droplet_kit/models/tagged_resources'
  autoload :TaggedDropletsResources, 'droplet_kit/models/tagged_droplets_resources'
  autoload :Volume, 'droplet_kit/models/volume'
  autoload :LoadBalancer, 'droplet_kit/models/load_balancer'
  autoload :StickySession, 'droplet_kit/models/sticky_session'
  autoload :HealthCheck, 'droplet_kit/models/health_check'
  autoload :ForwardingRule, 'droplet_kit/models/forwarding_rule'
  autoload :Certificate, 'droplet_kit/models/certificate'
  autoload :Firewall, 'droplet_kit/models/firewall'
  autoload :FirewallRule, 'droplet_kit/models/firewall_rule'
  autoload :FirewallInboundRule, 'droplet_kit/models/firewall_inbound_rule'
  autoload :FirewallOutboundRule, 'droplet_kit/models/firewall_outbound_rule'
  autoload :FirewallPendingChange, 'droplet_kit/models/firewall_pending_change'

  # Resources
  autoload :DropletResource, 'droplet_kit/resources/droplet_resource'
  autoload :ActionResource, 'droplet_kit/resources/action_resource'
  autoload :DomainResource, 'droplet_kit/resources/domain_resource'
  autoload :DomainRecordResource, 'droplet_kit/resources/domain_record_resource'
  autoload :DropletActionResource, 'droplet_kit/resources/droplet_action_resource'
  autoload :ImageResource, 'droplet_kit/resources/image_resource'
  autoload :ImageActionResource, 'droplet_kit/resources/image_action_resource'
  autoload :SSHKeyResource, 'droplet_kit/resources/ssh_key_resource'
  autoload :RegionResource, 'droplet_kit/resources/region_resource'
  autoload :SizeResource, 'droplet_kit/resources/size_resource'
  autoload :AccountResource, 'droplet_kit/resources/account_resource'
  autoload :DropletUpgradeResource, 'droplet_kit/resources/droplet_upgrade_resource'
  autoload :FloatingIpResource, 'droplet_kit/resources/floating_ip_resource'
  autoload :FloatingIpActionResource, 'droplet_kit/resources/floating_ip_action_resource'
  autoload :TagResource, 'droplet_kit/resources/tag_resource'
  autoload :VolumeResource, 'droplet_kit/resources/volume_resource'
  autoload :VolumeActionResource, 'droplet_kit/resources/volume_action_resource'
  autoload :SnapshotResource, 'droplet_kit/resources/snapshot_resource'
  autoload :LoadBalancerResource, 'droplet_kit/resources/load_balancer_resource'
  autoload :CertificateResource, 'droplet_kit/resources/certificate_resource'
  autoload :FirewallResource, 'droplet_kit/resources/firewall_resource'

  # JSON Maps
  autoload :DropletMapping, 'droplet_kit/mappings/droplet_mapping'
  autoload :ImageMapping, 'droplet_kit/mappings/image_mapping'
  autoload :RegionMapping, 'droplet_kit/mappings/region_mapping'
  autoload :SizeMapping, 'droplet_kit/mappings/size_mapping'
  autoload :NetworkMapping, 'droplet_kit/mappings/network_mapping'
  autoload :NetworkDetailMapping, 'droplet_kit/mappings/network_detail_mapping'
  autoload :KernelMapping, 'droplet_kit/mappings/kernel_mapping'
  autoload :SnapshotMapping, 'droplet_kit/mappings/snapshot_mapping'
  autoload :ActionMapping, 'droplet_kit/mappings/action_mapping'
  autoload :DomainMapping, 'droplet_kit/mappings/domain_mapping'
  autoload :DomainRecordMapping, 'droplet_kit/mappings/domain_record_mapping'
  autoload :DropletActionMapping, 'droplet_kit/mappings/droplet_action_mapping'
  autoload :ImageActionMapping, 'droplet_kit/mappings/image_action_mapping'
  autoload :SSHKeyMapping, 'droplet_kit/mappings/ssh_key_mapping'
  autoload :AccountMapping, 'droplet_kit/mappings/account_mapping'
  autoload :DropletUpgradeMapping, 'droplet_kit/mappings/droplet_upgrade_mapping'
  autoload :FloatingIpMapping, 'droplet_kit/mappings/floating_ip_mapping'
  autoload :TagMapping, 'droplet_kit/mappings/tag_mapping'
  autoload :TaggedResourcesMapping, 'droplet_kit/mappings/tagged_resources_mapping'
  autoload :TaggedDropletsResourcesMapping, 'droplet_kit/mappings/tagged_droplets_resources_mapping'
  autoload :VolumeMapping, 'droplet_kit/mappings/volume_mapping'
  autoload :LoadBalancerMapping, 'droplet_kit/mappings/load_balancer_mapping'
  autoload :StickySessionMapping, 'droplet_kit/mappings/sticky_session_mapping'
  autoload :HealthCheckMapping, 'droplet_kit/mappings/health_check_mapping'
  autoload :ForwardingRuleMapping, 'droplet_kit/mappings/forwarding_rule_mapping'
  autoload :CertificateMapping, 'droplet_kit/mappings/certificate_mapping'
  autoload :FirewallMapping, 'droplet_kit/mappings/firewall_mapping'
  autoload :FirewallRuleMapping, 'droplet_kit/mappings/firewall_rule_mapping'
  autoload :FirewallInboundRuleMapping, 'droplet_kit/mappings/firewall_inbound_rule_mapping'
  autoload :FirewallOutboundRuleMapping, 'droplet_kit/mappings/firewall_outbound_rule_mapping'
  autoload :FirewallPendingChangeMapping, 'droplet_kit/mappings/firewall_pending_change_mapping'

  # Utils
  autoload :PaginatedResource, 'droplet_kit/paginated_resource'
  autoload :ErrorHandlingResourcable, 'droplet_kit/error_handling_resourcable'

  # Errors
  autoload :ErrorMapping, 'droplet_kit/mappings/error_mapping'
  Error = Class.new(StandardError)
  FailedCreate = Class.new(DropletKit::Error)
  FailedUpdate = Class.new(DropletKit::Error)

  class RateLimitReached < DropletKit::Error
    attr_accessor :reset_at
    attr_writer :limit, :remaining

    def limit
      @limit.to_i if @limit
    end

    def remaining
      @remaining.to_i if @remaining
    end
  end
end
