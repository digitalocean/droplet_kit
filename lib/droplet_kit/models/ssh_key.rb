module DropletKit
  class SSHKey < BaseModel
    attribute :id
    attribute :fingerprint
    attribute :public_key
    attribute :name
  end
end