# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'droplet_kit/utils'

module DropletKit
  class Client
    DEFAULT_OPEN_TIMEOUT = 60
    DEFAULT_TIMEOUT = 120
    DEFAULT_RETRY_MAX = 3
    DEFAULT_RETRY_WAIT_MIN = 0

    DIGITALOCEAN_API = 'https://api.digitalocean.com'

    attr_reader :access_token, :api_url, :open_timeout, :timeout, :user_agent, :retry_max, :retry_wait_min

    def initialize(options = {})
      options = DropletKit::Utils.transform_keys(options, &:to_sym)
      @access_token   = options[:access_token]
      @api_url        = options[:api_url] || DIGITALOCEAN_API
      @open_timeout   = options[:open_timeout] || DEFAULT_OPEN_TIMEOUT
      @timeout        = options[:timeout] || DEFAULT_TIMEOUT
      @user_agent     = options[:user_agent]
      @retry_max      = options[:retry_max] || DEFAULT_RETRY_MAX
      @retry_wait_min = options[:retry_wait_min] || DEFAULT_RETRY_WAIT_MIN
    end

    def connection
      @faraday ||= Faraday.new connection_options do |req|
        req.adapter :net_http
        req.options.open_timeout = open_timeout
        req.options.timeout = timeout
        req.request :retry, {
          max: @retry_max,
          interval: @retry_wait_min,
          retry_statuses: [429],
          # faraday-retry supports both the Retry-After and RateLimit-Reset
          # headers, however, it favours the RateLimit-Reset one. To force it
          # to use the Retry-After header, we override the header that it
          # expects for the RateLimit-Reset header to something that we know
          # we don't set.
          rate_limit_reset_header: 'undefined'
        }
      end
    end

    def self.resources
      {
        actions: ActionResource,
        cdns: CDNResource,
        certificates: CertificateResource,
        container_registry: ContainerRegistryResource,
        container_registry_repository: ContainerRegistryRepositoryResource,
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
        invoices: InvoiceResource,
        load_balancers: LoadBalancerResource,
        regions: RegionResource,
        sizes: SizeResource,
        ssh_keys: SSHKeyResource,
        snapshots: SnapshotResource,
        account: AccountResource,
        balance: BalanceResource,
        floating_ips: FloatingIpResource,
        floating_ip_actions: FloatingIpActionResource,
        reserved_ips: ReservedIpResource,
        reserved_ip_actions: ReservedIpActionResource,
        tags: TagResource,
        projects: ProjectResource,
        volumes: VolumeResource,
        volume_actions: VolumeActionResource,
        vpcs: VPCResource
      }
    end

    def method_missing(name, *args, &block)
      if self.class.resources.key?(name)
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
