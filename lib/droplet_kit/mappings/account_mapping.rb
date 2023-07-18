# frozen_string_literal: true

module DropletKit
  class AccountMapping
    include Kartograph::DSL

    kartograph do
      root_key singular: 'account', scopes: [:read]
      mapping Account

      scoped :read do
        property :droplet_limit
        property :floating_ip_limit
        property :name
        property :email
        property :uuid
        property :email_verified
        property :team
      end
    end
  end

  class AccountTeamMapping
    include Kartograph::DSL

    kartograph do
      root_key singular: 'team', scopes: [:read]
      mapping AccountTeam

      scoped :read do
        property :uuid
        property :name
      end
    end
  end
end
