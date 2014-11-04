module DropletKit
  class Account < BaseModel
    attribute :droplet_limit
    attribute :email
    attribute :uuid
    attribute :email_verified
  end
end