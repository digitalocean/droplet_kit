# frozen_string_literal: true

module DropletKit
  class ReservedIpv6ActionResource < ResourceKit::Resource
    resources do
      default_handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      default_handler(400) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }

      action :assign, 'POST /v2/reserved_ipv6/:ip/actions' do
        body { |hash| { type: 'assign', droplet_id: hash[:droplet_id] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :unassign, 'POST /v2/reserved_ipv6/:ip/actions' do
        body { |hash| { type: 'unassign' }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end
    end
  end
end
