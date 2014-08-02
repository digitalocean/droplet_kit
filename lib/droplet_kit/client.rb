require 'faraday'

module DropletKit
  class Client
    DIGITALOCEAN_API = 'https://api.digitalocean.com'

    attr_reader :access_token

    def initialize(options = {})
      @access_token = options[:access_token]
    end

    def connection
      Faraday.new(connection_options) do |req|
        req.adapter :net_http
      end
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