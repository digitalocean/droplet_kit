# frozen_string_literal: true

module DropletKit
  class DatabaseKafkaConfigMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseKafkaConfig
      root_key singular: 'config', scopes: %i[read update]

      scoped :read, :update do
        %i[compression_type
           group_initial_rebalance_delay_ms
           group_min_session_timeout_ms
           group_max_session_timeout_ms
           connections_max_idle_ms
           max_incremental_fetch_session_cache_slots
           message_max_bytes
           offsets_retention_minutes
           log_cleaner_delete_retention_ms
           log_cleaner_min_cleanable_ratio
           log_cleaner_max_compaction_lag_ms
           log_cleaner_min_compaction_lag_ms
           log_cleanup_policy
           log_flush_interval_messages
           log_flush_interval_ms
           log_index_interval_bytes
           log_index_size_max_bytes
           log_message_downconversion_enable
           log_message_timestamp_type
           log_message_timestamp_difference_max_ms
           log_preallocate
           log_retention_bytes
           log_retention_hours
           log_retention_ms
           log_roll_jitter_ms
           log_roll_ms
           log_segment_bytes
           log_segment_delete_delay_ms
           auto_create_topics_enable
           min_insync_replicas
           num_partitions
           default_replication_factor
           replica_fetch_max_bytes
           replica_fetch_response_max_bytes
           max_connections_per_ip
           producer_purgatory_purge_interval_requests
           socket_request_max_bytes
           transaction_state_log_segment_bytes
           transaction_remove_expired_transaction_cleanup_interval_ms].each do |key|
          property(key)
        end
      end
    end
  end
end
