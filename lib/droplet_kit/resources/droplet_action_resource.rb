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
    end
  end
end