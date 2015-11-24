module DropletKit
  class Account < BaseModel
    attribute :droplet_limit
    attribute :floating_ip_limit
    attribute :email
    attribute :uuid
    attribute :email_verified
  end
end
