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

    # region  object
    # networks  object
    # size  object
    # image object
    # kernel  object
  end
end

