require 'faraday'
require 'droplet_kit/utils'

module DropletKit
  class Client
    DEFAULT_OPEN_TIMEOUT = 60
    DEFAULT_TIMEOUT = 120
    DIGITALOCEAN_API = 'https://api.digitalocean.com'

    attr_reader :access_token, :api_url, :open_timeout, :timeout, :user_agent

    def initialize(options = {})
      options = DropletKit::Utils.transform_keys(options, &:to_sym)
      @access_token = options[:access_token]
      @api_url      = options[:api_url] || DIGITALOCEAN_API
      @open_timeout = options[:open_timeout] || DEFAULT_OPEN_TIMEOUT
      @timeout      = options[:timeout] || DEFAULT_TIMEOUT
      @user_agent   = options[:user_agent]
    end

    def connection
      @faraday ||= Faraday.new connection_options do |req|
        req.adapter :net_http
        req.options.open_timeout = open_timeout
        req.options.timeout = timeout
      end
    end

    def self.resources
      {
        actions: ActionResource,
        cdns: CDNResource,
        certificates: CertificateResource,
        container_registry: ContainerRegistryResource,
        databases: DatabaseResource,
        droplets: DropletResource,
        kubernetes_clusters: KubernetesClusterResource,
        kubernetes_options: KubernetesOptionsResource,
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
        projects: ProjectResource,
        volumes: VolumeResource,
        volume_actions: VolumeActionResource,
        vpcs: VPCResource
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

    def default_user_agent
      "DropletKit/#{DropletKit::VERSION} Faraday/#{Faraday::VERSION}"
    end

    private

    def connection_options
      {
        url: @api_url,
        headers: {
          content_type: 'application/json',
          authorization: "Bearer #{access_token}",
          user_agent: "#{user_agent} #{default_user_agent}".strip
        }
      }
    end
  end
end
