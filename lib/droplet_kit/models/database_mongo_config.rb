# frozen_string_literal: true

module DropletKit
  class DatabaseMongoConfig < BaseModel
    %i[default_read_concern
       default_write_concern
       transaction_lifetime_limit_seconds
       slow_op_threshold_ms
       verbosity].each do |key|
      attribute(key)
    end
  end
end
