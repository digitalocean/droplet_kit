# frozen_string_literal: true

module DropletKit
  class FirewallOutboundRule < BaseModel
    attribute :protocol
    attribute :ports
    attribute :destinations
  end
end
