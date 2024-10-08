# frozen_string_literal: true

module DropletKit
  class DatabasePostgresPgbouncerConfigMapping
    include Kartograph::DSL
    kartograph do
      mapping DatabasePostgresPgbouncerConfig

      scoped :read, :update do
        property :server_reset_query_always
        property :ignore_startup_parameters
        property :min_pool_size
        property :server_lifetime
        property :server_idle_timeout
        property :autodb_pool_size
        property :autodb_pool_mode
        property :autodb_max_db_connections
        property :autodb_idle_timeout
      end
    end
  end

  class DatabasePostgresTimescaledbConfigMapping
    include Kartograph::DSL
    kartograph do
      mapping DatabasePostgresTimescaledbConfig
      property :max_background_workers, scopes: %i[read update]
    end
  end

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
           backup_hour
           backup_minute
           work_mem].each do |key|
          property(key)
        end

        property :pg_partman_bgw_role, key: 'pg_partman_bgw.role'
        property :pg_partman_bgw_interval, key: 'pg_partman_bgw.interval'
        property :pg_stat_statements_track, key: 'pg_stat_statements.track'

        property :pgbouncer, include: DatabasePostgresPgbouncerConfigMapping
        property :timescaledb, include: DatabasePostgresTimescaledbConfigMapping
      end
    end
  end
end
