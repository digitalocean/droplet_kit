module DropletKit
  class SSHKeyMapping
    include Kartograph::DSL

    kartograph do
      mapping SSHKey
      root_key singular: 'ssh_key', plural: 'ssh_keys', scopes: [:read]

      property :id, :fingerprint, :public_key, :name,
        scopes: [:read]

      property :name, :public_key, scopes: [:create]

      property :name, scopes: [:update]
    end
  end
end
