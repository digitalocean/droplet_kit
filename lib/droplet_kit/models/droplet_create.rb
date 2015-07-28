module DropletKit
  class DropletCreate < BaseModel
    attribute :name
    attribute :region
    attribute :size
    attribute :image
    attribute :ssh_keys
    attribute :backups
    attribute :ipv6
    attribute :user_data
    attribute :private_networking
  end
end
