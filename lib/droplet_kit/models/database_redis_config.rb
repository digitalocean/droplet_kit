# frozen_string_literal: true

module DropletKit
  class DatabaseRedisConfig < BaseModel
    %i[redis_maxmemory_policy
       redis_pubsub_client_output_buffer_limit
       redis_number_of_databases
       redis_io_threads
       redis_lfu_log_factor
       redis_lfu_decay_time
       redis_ssl
       redis_timeout
       redis_notify_keyspace_events
       redis_persistence
       redis_acl_channels_default].each do |key|
      attribute(key)
    end
  end
end
