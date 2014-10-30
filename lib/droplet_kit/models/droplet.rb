module DropletKit
  class Droplet < BaseModel
    [:id, :name, :memory, :vcpus, :disk, :locked, :created_at,
      :status, :backup_ids, :snapshot_ids, :action_ids, :features,
      :region, :image, :size, :networks, :kernel].each do |key|
      attribute(key)
    end

    # Used for creates
    attribute :ssh_keys
    attribute :backups
    attribute :ipv6
    attribute :user_data
    attribute :private_networking
  end
end

