# frozen_string_literal: true

module DropletKit
  class DatabasePostgresConfigMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabasePostgresConfig
      root_key singular: 'config', scopes: %i[read update]

      scoped :read, :update do
        %i[autovacuum_freeze_max_age
           autovacuum_max_workers
           autovacuum_naptime
           autovacuum_vacuum_threshold
           autovacuum_analyze_threshold
           autovacuum_vacuum_scale_factor
           autovacuum_analyze_scale_factor
           autovacuum_vacuum_cost_delay
           autovacuum_vacuum_cost_limit
           bgwriter_delay
           bgwriter_flush_after
           bgwriter_lru_maxpages
           bgwriter_lru_multiplier
           deadlock_timeout
           default_toast_compression
           idle_in_transaction_session_timeout
           jit
           log_autovacuum_min_duration
           log_error_verbosity
           log_line_prefix
           log_min_duration_statement
           max_files_per_process
           max_prepared_transactions
           max_pred_locks_per_transaction
           max_locks_per_transaction
           max_stack_depth
           max_standby_archive_delay
           max_standby_streaming_delay
           max_replication_slots
           max_logical_replication_workers
           max_parallel_workers
           max_parallel_workers_per_gather
           max_worker_processes
           pg_partman_bgw
           pg_partman_bgw
           pg_stat_statements
           temp_file_limit
           timezone
           track_activity_query_size
           track_commit_timestamp
           track_functions
           track_io_timing
           max_wal_senders
           wal_sender_timeout
           wal_writer_delay
           shared_buffers_percentage
           pgbouncer
           backup_hour
           backup_minute
           work_mem
           timescaledb].each do |key|
          property(key)
          # TODO: pgbouncer and timescaledb are objects
        end
      end
    end
  end
end
