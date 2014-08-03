module DropletKit
  class KernelMapping
    include Kartograph::DSL

    kartograph do
      mapping Kernel

      property :id, scopes: [:read]
      property :name, scopes: [:read]
      property :version, scopes: [:read]
    end
  end
end