module DropletKit
  class ForwardingRule < BaseModel
    attribute :entry_protocol
    attribute :entry_port
    attribute :target_protocol
    attribute :target_port
    attribute :certificate_id
    attribute :tls_passthrough
  end
end
