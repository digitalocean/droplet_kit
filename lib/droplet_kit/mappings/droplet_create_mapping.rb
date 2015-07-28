module DropletKit
  class DropletCreateMapping
    include Kartograph::DSL

    kartograph do
      mapping DropletCreate

      # Create properties arent quite the same
      property :name, scopes: [:create]
      property :region, scopes: [:create]
      property :size, scopes: [:create]
      property :image, scopes: [:create]
      property :ssh_keys, scopes: [:create]
      property :backups, scopes: [:create]
      property :ipv6, scopes: [:create]
      property :user_data, scopes: [:create]
      property :private_networking, scopes: [:create]
    end
  end
end
