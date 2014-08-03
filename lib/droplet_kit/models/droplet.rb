module DropletKit
  class Droplet < BaseModel
    attribute :id
    attribute :name
    attribute :memory
    attribute :vcpus
    attribute :disk
    attribute :locked
    attribute :created_at
    attribute :status
    attribute :backup_ids
    attribute :snapshot_ids
    attribute :action_ids
    attribute :features

    attribute :region
    attribute :image
    attribute :size
    attribute :networks
    attribute :kernel

    # Used for creates
    attribute :ssh_keys
    attribute :backups
    attribute :ipv6
  end
end

