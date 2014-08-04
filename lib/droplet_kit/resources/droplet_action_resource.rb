module DropletKit
  class DropletActionResource < ResourceKit::Resource
    ACTIONS_WITHOUT_INPUT = %w(reboot power_cycle shutdown power_off
      power_on password_reset enable_ipv6 disable_backups enable_private_networking)

    resources do
      ACTIONS_WITHOUT_INPUT.each do |action_name|
        action action_name.to_sym do
          path '/v2/droplets/:droplet_id/actions'
          verb :post
          body { |_| { type: action_name }.to_json }
          handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
        end
      end

      action :snapshot do
        path '/v2/droplets/:droplet_id/actions'
        verb :post
        body { |hash| { type: 'snapshot', name: hash[:name] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :kernel do
        path '/v2/droplets/:droplet_id/actions'
        verb :post
        body { |hash| { type: 'kernel', kernel: hash[:kernel] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :rename do
        path '/v2/droplets/:droplet_id/actions'
        verb :post
        body { |hash| { type: 'rename', name: hash[:name] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :rebuild do
        path '/v2/droplets/:droplet_id/actions'
        verb :post
        body { |hash| { type: 'rebuild', image: hash[:image] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :restore do
        path '/v2/droplets/:droplet_id/actions'
        verb :post
        body { |hash| { type: 'restore', image: hash[:image] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :resize do
        path '/v2/droplets/:droplet_id/actions'
        verb :post
        body { |hash| { type: 'resize', size: hash[:size] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end
    end
  end
end