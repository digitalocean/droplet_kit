module DropletKit
  class DatabaseFirewallRule < BaseModel
    attribute :type
    attribute :value
    attribute :uuid
    attribute :cluster_uuid
    attribute :created_at
  end
end
