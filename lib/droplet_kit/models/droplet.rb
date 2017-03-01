module DropletKit
  class Droplet < BaseModel
    [:id, :name, :memory, :vcpus, :disk, :locked, :created_at,
      :status, :backup_ids, :snapshot_ids, :action_ids, :features,
      :region, :image, :networks, :kernel, :size_slug, :tags].each do |key|
      attribute(key)
    end

    # Used for creates
    attribute :names
    attribute :volumes
    attribute :ssh_keys
    attribute :backups
    attribute :monitoring
    attribute :size
    attribute :ipv6
    attribute :user_data
    attribute :private_networking

    def public_ip
      network = network_for(:v4, 'public')
      network && network.ip_address
    end

    def private_ip
      network = network_for(:v4, 'private')
      network && network.ip_address
    end

    private

    def network_for(type, publicity)
      networks = case type
                 when :v4 then self.networks.v4
                 when :v6 then self.networks.v6
                 end

      networks.find do |network|
        network.type == publicity
      end
    end
  end
end

