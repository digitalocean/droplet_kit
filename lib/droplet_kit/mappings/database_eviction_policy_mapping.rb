# frozen_string_literal: true

module DropletKit
  class DatabaseEvictionPolicyMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseEvictionPolicy

      property :eviction_policy, scopes: %i[read update]
    end
  end
end
