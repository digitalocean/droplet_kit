module DropletKit
  class AccountMapping
    include Kartograph::DSL

    kartograph do
      root_key singular: 'account', scopes: [:read]
      mapping Account

      scoped :read do
        property :droplet_limit
        property :floating_ip_limit
        property :email
        property :uuid
        property :email_verified
      end
    end
  end
end
