# frozen_string_literal: true

module DropletKit
  class DatabaseMongoConfigMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseMongoConfig
      root_key singular: 'config', scopes: %i[read update]

      scoped :read, :update do
        %i[default_read_concern
           default_write_concern
           transaction_lifetime_limit_seconds
           slow_op_threshold_ms
           verbosity].each do |key|
          property(key)
        end
      end
    end
  end
end
