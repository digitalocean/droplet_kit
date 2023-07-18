# frozen_string_literal: true

module DropletKit
  class Account < BaseModel
    attribute :droplet_limit
    attribute :floating_ip_limit
    attribute :name
    attribute :email
    attribute :uuid
    attribute :email_verified
    attribute :team
  end

  class AccountTeam < BaseModel
    attribute :uuid
    attribute :name
  end
end
