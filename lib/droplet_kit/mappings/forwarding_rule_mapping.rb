module DropletKit
  class ForwardingRuleMapping
    include Kartograph::DSL

    kartograph do
      root_key plural: 'forwarding_rules', scopes: [:create, :update]
      mapping ForwardingRule

      scoped :read, :create, :update do
        property :entry_protocol
        property :entry_port
        property :target_protocol
        property :target_port
        property :certificate_id
        property :tls_passthrough
      end
    end
  end
end
