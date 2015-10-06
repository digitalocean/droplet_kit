module DropletKit
  class DropletActionResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    ACTIONS_WITHOUT_INPUT = %w(reboot power_cycle shutdown power_off
      power_on password_reset enable_ipv6 disable_backups enable_private_networking)

    resources do
      default_handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }

      ACTIONS_WITHOUT_INPUT.each do |action_name|
        action action_name.to_sym, 'POST /v2/droplets/:droplet_id/actions' do
          body { |_| { type: action_name }.to_json }
          handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
        end
      end

      action :snapshot, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'snapshot', name: hash[:name] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :change_kernel, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'change_kernel', kernel: hash[:kernel] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :rename, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'rename', name: hash[:name] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :rebuild, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'rebuild', image: hash[:image] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :restore, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'restore', image: hash[:image] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :resize, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'resize', size: hash[:size], disk: hash[:disk] }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :upgrade, 'POST /v2/droplets/:droplet_id/actions' do
        body { |hash| { type: 'upgrade' }.to_json }
        handler(201, 200) { |response| ActionMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/droplets/:droplet_id/actions/:id' do
        handler(200) { |response| ActionMapping.extract_single(response.body, :read) }
      end
    end
  end
end