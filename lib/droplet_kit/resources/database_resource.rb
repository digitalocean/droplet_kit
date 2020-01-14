module DropletKit
  class DatabaseResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find_cluster, 'GET /v2/databases/:id' do
        handler(200) { |response| DatabaseClusterMapping.extract_single(response.body, :read) }
      end

      action :all_clusters, 'GET /v2/databases' do
        query_keys :per_page, :page
        handler(200) { |response| DatabaseClusterMapping.extract_collection(response.body, :read) }
      end

      action :create_cluster, 'POST /v2/databases' do
        body { |object| DatabaseClusterMapping.representation_for(:create, object) }
        handler(201) { |response, database| DatabaseClusterMapping.extract_into_object(database, response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :resize_cluster, 'PUT /v2/databases/:id/resize' do
        body { |object| DatabaseClusterMapping.representation_for(:resize, object) }
        handler(201) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :migrate_cluster, 'PUT /v2/databases/:id/migrate' do
        body { |object| DatabaseClusterMapping.representation_for(:migrate, object) }
        handler(201) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :update_maintenance_window, 'PUT /v2/databases/:id/maintenance' do
        body { |object| DatabaseMaintenanceWindowMapping.representation_for(:update, object) }
        handler(204) { |response| true }
      end

      action :list_backups, 'GET /v2/databases/:id/backups' do
        handler(200) { |response| DatabaseBackupMapping.extract_collection(response.body, :read) }
      end

      action :restore_from_backup, 'POST /v2/databases' do
        body { |object| DatabaseClusterMapping.representation_for(:restore, object) }
        handler(201) { |response, database| DatabaseClusterMapping.extract_into_object(database, response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :delete_cluster, 'DELETE /v2/databases/:id' do
        handler(204) { |response| true }
      end

      action :create_db, 'POST /v2/databases/:id/dbs' do
        body { |object| DatabaseMapping.representation_for(:create, object) }
        handler(201) { |response, database| DatabaseMapping.extract_into_object(database, response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :find_db, 'GET /v2/databases/:id/dbs/:name' do
        handler(200) { |response| DatabaseMapping.extract_single(response.body, :read) }
      end

      action :all_dbs, 'GET /v2/databases/:id/dbs' do
        handler(200) { |response| DatabaseMapping.extract_collection(response.body, :read) }
      end

      action :delete_db, 'DELETE /v2/databases/:id/dbs/:name' do
        handler(204) { |response| true }
      end

      action :set_maintenance_window, 'PUT /v2/databases/:id/maintenance' do
        body { |object| DatabaseMaintenanceWindowMapping.representation_for(:update, object) }
        handler(204) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :list_firewall_rules, 'GET /v2/databases/:id/firewall' do
        handler(200) { |response| DatabaseFirewallRuleMapping.extract_collection(response.body, :read) }
      end

      action :set_firewall_rules, 'PUT /v2/databases/:id/firewall' do
        body { |object| DatabaseFirewallRuleMapping.represent_collection_for(:update, object) }
        handler(204) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :create_read_only_replica, 'POST /v2/databases/:id/replicas' do
        body { |object| DatabaseClusterMapping.representation_for(:create, object) }
        handler(201) { |response| DatabaseReplicaMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :find_read_only_replica, 'GET /v2/databases/:id/replicas/:name' do
        handler(200) { |response| DatabaseReplicaMapping.extract_single(response.body, :read) }
      end

      action :list_read_only_replicas, 'GET /v2/databases/:id/replicas' do
        handler(200) { |response| DatabaseReplicaMapping.extract_single(response.body, :read) }
      end

      action :delete_read_only_replica, 'DELETE /v2/databases/:id/replicas/:name' do
        handler(204) { |response| true }
      end

      # Next up!
      action :create_database_user, 'POST /v2/databases/:id/users' do
        body { |object| DatabaseUserMapping.representation_for(:create, object) }
        handler(201) { |response| DatabaseUserMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :find_database_user, 'GET /v2/databases/:id/users/:name' do
        handler(200) { |response| DatabaseUserMapping.extract_single(response.body, :read) }
      end

      action :list_database_users, 'GET /v2/databases/:id/users' do
        handler(200) { |response| DatabaseUserMapping.extract_collection(response.body, :read) }
      end

      action :delete_database_user, 'DELETE /v2/databases/:id/users/:name' do
        handler(204) { |response| true }
      end

      action :create_connection_pool, 'POST /v2/databases/:id/pools' do
        body { |object| DatabaseConnectionPoolMapping.representation_for(:create, object) }
        handler(201) { |response| DatabaseConnectionPoolMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :find_connection_pool, 'GET /v2/databases/:id/pools/:name' do
        handler(200) { |response| DatabaseConnectionPoolMapping.extract_single(response.body, :read) }
      end

      action :list_connection_pools, 'GET /v2/databases/:id/pools' do
        handler(200) { |response| DatabaseConnectionPoolMapping.extract_collection(response.body, :read) }
      end

      action :delete_connection_pool, 'DELETE /v2/databases/:id/pools/:name' do
        handler(204) { |response| true }
      end

      action :set_eviction_policy, 'PUT /v2/databases/:id/eviction_policy' do
        body { |object| DatabaseEvictionPolicyMapping.representation_for(:update, object) }
        handler(204) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :get_eviction_policy, 'GET /v2/databases/:id/eviction_policy' do
        handler(200) { |response| DatabaseEvictionPolicyMapping.extract_single(response.body, :read) }
      end

      action :set_sql_mode, 'PUT /v2/databases/:id/sql_mode' do
        body { |object| DatabaseSQLModeMapping.representation_for(:update, object) }
        handler(204) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :get_sql_mode, 'GET /v2/databases/:id/sql_mode' do
        handler(200) { |response| DatabaseSQLModeMapping.extract_single(response.body, :read) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
