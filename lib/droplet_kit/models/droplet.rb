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
      network = networks.v4.find do |network|
        network.type == 'public'
      end

      network && network.ip_address
    end

    def private_ip
      network = networks.v4.find do |network|
        network.type == 'private'
      end

      network && network.ip_address
    end
  end
end

