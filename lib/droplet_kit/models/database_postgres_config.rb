# frozen_string_literal: true

module DropletKit
  class DatabasePostgresTimescaledbConfig < BaseModel
    attribute :max_background_workers
  end

  class DatabasePostgresPgbouncerConfig < BaseModel
    attribute :server_reset_query_always
    attribute :ignore_startup_parameters
    attribute :min_pool_size
    attribute :server_lifetime
    attribute :server_idle_timeout
    attribute :autodb_pool_size
    attribute :autodb_pool_mode
    attribute :autodb_max_db_connections
    attribute :autodb_idle_timeout
  end

  class DatabasePostgresConfig < BaseModel
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
       pg_partman_bgw_role
       pg_partman_bgw_interval
       pg_stat_statements_track
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
      attribute(key)
    end

    attribute :timescaledb, DatabasePostgresTimescaledbConfig
    attribute :pgbouncer, DatabasePostgresPgbouncerConfig
  end
end
