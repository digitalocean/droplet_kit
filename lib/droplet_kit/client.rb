require 'faraday'

module DropletKit
  class Client
    DIGITALOCEAN_API = 'https://api.digitalocean.com'

    attr_reader :access_token

    def initialize(options = {})
      @access_token = options.with_indifferent_access[:access_token]
    end

    def connection
      @faraday ||= Faraday.new connection_options do |req|
        req.adapter :net_http
      end
    end

    def self.resources
      {
        actions: ActionResource,
        certificates: CertificateResource,
        droplets: DropletResource,
        domains: DomainResource,
        domain_records: DomainRecordResource,
        droplet_actions: DropletActionResource,
        firewalls: FirewallResource,
        images: ImageResource,
        image_actions: ImageActionResource,
        load_balancers: LoadBalancerResource,
        regions: RegionResource,
        sizes: SizeResource,
        ssh_keys: SSHKeyResource,
        snapshots: SnapshotResource,
        account: AccountResource,
        floating_ips: FloatingIpResource,
        floating_ip_actions: FloatingIpActionResource,
        tags: TagResource,
        volumes: VolumeResource,
        volume_actions: VolumeActionResource
      }
    end

    def method_missing(name, *args, &block)
      if self.class.resources.keys.include?(name)
        resources[name] ||= self.class.resources[name].new(connection: connection)
        resources[name]
      else
        super
      end
    end

    def resources
      @resources ||= {}
    end

    private

    def connection_options
      {
        url: DIGITALOCEAN_API,
        headers: {
          content_type: 'application/json',
          authorization: "Bearer #{access_token}"
        }
      }
    end
  end
end
