# frozen_string_literal: true

module DropletKit
  class DatabaseOpensearchConfig < BaseModel
    %i[http_max_content_length_bytes
       http_max_header_size_bytes
       http_max_initial_line_length_bytes
       indices_query_bool_max_clause_count
       indices_fielddata_cache_size_percentage
       indices_memory_index_buffer_size_percentage
       indices_memory_min_index_buffer_size_mb
       indices_memory_max_index_buffer_size_mb
       indices_queries_cache_size_percentage
       indices_recovery_max_mb_per_sec
       indices_recovery_max_concurrent_file_chunks
       thread_pool_search_size
       thread_pool_search_throttled_size
       thread_pool_get_size
       thread_pool_analyze_size
       thread_pool_write_size
       thread_pool_force_merge_size
       thread_pool_search_queue_size
       thread_pool_search_throttled_queue_size
       thread_pool_get_queue_size
       thread_pool_analyze_queue_size
       thread_pool_write_queue_size
       ism_enabled
       ism_history_enabled
       ism_history_max_age_hours
       ism_history_max_docs
       ism_history_rollover_check_period_hours
       ism_history_rollover_retention_period_days
       search_max_buckets
       action_auto_create_index_enabled
       enable_security_audit
       action_destructive_requires_name
       cluster_max_shards_per_node
       override_main_response_version
       script_max_compilations_rate
       cluster_routing_allocation_node_concurrent_recoveries
       reindex_remote_whitelist
       plugins_alerting_filter_by_backend_roles_enabled].each do |key|
      attribute(key)
    end
  end
end
