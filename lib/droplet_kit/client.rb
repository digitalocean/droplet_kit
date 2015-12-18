require 'faraday'

module DropletKit
  class Client
    DIGITALOCEAN_API = 'https://api.digitalocean.com'

    attr_reader :access_token

    def initialize(options = {})
      @access_token = options.with_indifferent_access[:access_token]
    end

    def connection
      Faraday.new(connection_options) do |req|
        req.adapter :net_http
      end
    end

    def self.resources
      {
        actions: ActionResource,
        droplets: DropletResource,
        domains: DomainResource,
        domain_records: DomainRecordResource,
        droplet_actions: DropletActionResource,
        images: ImageResource,
        image_actions: ImageActionResource,
        regions: RegionResource,
        sizes: SizeResource,
        ssh_keys: SSHKeyResource,
        account: AccountResource,
        floating_ips: FloatingIpResource,
        floating_ip_actions: FloatingIpActionResource,
        tags: TagResource
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
