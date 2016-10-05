module DropletKit
  class Snapshot < BaseModel
    attribute :id
    attribute :name
    attribute :regions
    attribute :created_at
    attribute :resource_id
    attribute :resource_type
    attribute :min_disk_size
    attribute :size_gigabytes
  end
end