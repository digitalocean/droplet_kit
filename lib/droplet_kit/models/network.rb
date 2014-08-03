module DropletKit
  class Network < Struct.new(:ip_address, :netmask, :gateway, :type, :cidr)
  end
end