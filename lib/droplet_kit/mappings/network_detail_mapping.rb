module DropletKit
  class NetworkDetailMapping
    include Kartograph::DSL

    kartograph do
      mapping Network

      property :ip_address, scopes: [:read]
      property :netmask, scopes: [:read]
      property :gateway, scopes: [:read]
      property :type, scopes: [:read]
      property :cidr, scopes: [:read]
    end
  end
end