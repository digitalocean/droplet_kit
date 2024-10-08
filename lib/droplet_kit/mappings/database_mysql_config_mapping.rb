# frozen_string_literal: true

module DropletKit
  class DatabaseMysqlConfigMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseMysqlConfig
      root_key singular: 'config', scopes: %i[read update]

      scoped :read, :update do
        %i[backup_hour
           backup_minute
           sql_mode
           connect_timeout
           default_time_zone
           group_concat_max_len
           information_schema_stats_expiry
           innodb_ft_min_token_size
           innodb_ft_server_stopword_table
           innodb_lock_wait_timeout
           innodb_log_buffer_size
           innodb_online_alter_log_max_size
           innodb_print_all_deadlocks
           innodb_rollback_on_timeout
           interactive_timeout
           internal_tmp_mem_storage_engine
           net_read_timeout
           net_write_timeout
           sql_require_primary_key
           wait_timeout
           max_allowed_packet
           max_heap_table_size
           sort_buffer_size
           tmp_table_size
           slow_query_log
           long_query_time
           binlog_retention_period
           innodb_change_buffer_max_size
           innodb_flush_neighbors
           innodb_read_io_threads
           innodb_write_io_threads
           innodb_thread_concurrency
           net_buffer_length].each do |key|
          property(key)
        end
      end
    end
  end
end
