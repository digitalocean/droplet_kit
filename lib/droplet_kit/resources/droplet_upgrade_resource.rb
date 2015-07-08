module DropletKit
  class DropletUpgradeResource < ResourceKit::Resource
    resources do
      action :all, 'GET /v2/droplet_upgrades' do
        handler(200) { |response| DropletUpgradeMapping.extract_collection(response.body, :read) }
      end
    end
  end
end