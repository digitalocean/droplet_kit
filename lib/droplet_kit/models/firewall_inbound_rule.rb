# frozen_string_literal: true

module DropletKit
  class FirewallInboundRule < BaseModel
    attribute :protocol
    attribute :ports
    attribute :sources
  end
end
