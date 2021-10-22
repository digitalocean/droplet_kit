# frozen_string_literal: true

module DropletKit
  Network = Struct.new(:ip_address, :netmask, :gateway, :type, :cidr)
end
