module DropletKit
  class Droplet < BaseModel
    [:id, :name, :memory, :vcpus, :disk, :locked, :created_at,
      :status, :backup_ids, :snapshot_ids, :action_ids, :features,
      :region, :image, :networks, :kernel, :size_slug].each do |key|
      attribute(key)
    end

    # Used for creates
    attribute :ssh_keys
    attribute :backups
    attribute :size
    attribute :ipv6
    attribute :user_data
    attribute :private_networking

    def public_ip
      networks.v4[0] && networks.v4[0].ip_address
    end

    def private_ip
      networks.v6[0] && networks.v6[0].ip_address
    end
  end
end

