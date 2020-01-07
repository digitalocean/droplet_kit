require 'spec_helper'

RSpec.describe DropletKit::DatabaseClusterResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_database_cluster do
    match do |cluster|
      expect(cluster).to be_kind_of(DropletKit::DatabaseCluster)
      expect(cluster.id).to eq("9cc10173-e9ea-4176-9dbc-a4cee4c4ff30")
      expect(cluster.name).to eq("backend")
      expect(cluster.engine).to eq("pg")
      expect(cluster.version).to eq("10")
      expect(cluster.region).to eq("nyc3")
      expect(cluster.size).to eq("db-s-2vcpu-4gb")
      expect(cluster.tags).to eq(["production"])
      expect(cluster.created_at).to eq("2019-01-11T18:37:36Z")
      expect(cluster.connection).to be_kind_of(DropletKit::DatabaseClusterConnection)
      expect(cluster.private_connection).to be_kind_of(DropletKit::DatabaseClusterConnection)
    end
  end

  RSpec::Matchers.define :match_configured_database_cluster do
    match do |cluster|
      expect(cluster).to be_kind_of(DropletKit::DatabaseCluster)
      expect(cluster.users).to all(be_kind_of(DropletKit::DatabaseClusterUser))
      expect(cluster.db_names).to all(be_kind_of(String))
      expect(cluster.num_nodes).to eq(2)
      expect(cluster.maintenance_window).to be_kind_of(DropletKit::DatabaseClusterMaintenanceWindow)
    end
  end

  RSpec::Matchers.define :match_database_cluster_backup do
    match do |cluster_backup|
      expect(cluster_backup).to be_kind_of(DropletKit::DatabaseClusterBackup)
      expect(cluster_backup.size_gigabytes).to eq(0.03357696)
      expect(cluster_backup.created_at).to eq("2019-01-11T18:42:27Z")
    end
  end

  RSpec::Matchers.define :match_read_only_database_cluster_replica do
    match do |cluster|
      expect(cluster).to be_kind_of(DropletKit::DatabaseCluster)
      expect(cluster.name).to eq("read-nyc3-01")
      expect(cluster.region).to eq("nyc3")
      expect(cluster.connection).to be_kind_of(DropletKit::DatabaseClusterConnection)
      expect(cluster.private_connection).to be_kind_of(DropletKit::DatabaseClusterConnection)
    end
  end

  RSpec::Matchers.define :match_cluster_user do
    match do |cluster_user|
      expect(cluster_user).to be_kind_of(DropletKit::DatabaseClusterUser)
      expect(cluster_user.name).to eq("app-01",)
      expect(cluster_user.role).to eq("normal",)
      expect(cluster_user.password).to eq("jge5lfxtzhx42iff")
    end
  end

  RSpec::Matchers.define :match_database do
    match do |database|
      expect(database).to be_kind_of(DropletKit::Database)
      expect(database.name).to eq("alpha")
    end
  end

  RSpec::Matchers.define :match_database_connection_pool do
    match do |pool|
      expect(pool).to be_kind_of(DropletKit::DatabaseClusterConnectionPool)
      expect(pool.user).to eq("doadmin")
      expect(pool.name).to eq("backend-pool")
      expect(pool.size).to eq(10)
      expect(pool.db).to eq("defaultdb")
      expect(pool.mode).to eq("transaction")
      expect(pool.connection).to be_kind_of(DropletKit::DatabaseClusterConnection)
    end
  end

  describe '#all' do
    let(:path) {'/v2/databases'}

    it 'returns all of the database clusters' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_response'), status: 200)
      database_clusters = resource.all

      expect(database_clusters).to all(be_kind_of(DropletKit::DatabaseCluster))
      expect(database_clusters.first).to match_database_cluster
      expect(database_clusters.first).to match_configured_database_cluster
      expect(request).to have_been_made
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'databases/list_response' }
      let(:api_path) { '/v2/databases' }
    end
  end

  describe '#find' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}" }

    it 'returns a singular database cluster' do  
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/get_response'), status: 200)
      database_cluster = resource.find(id: database_id)

      expect(database_cluster).to match_database_cluster
      expect(database_cluster).to match_configured_database_cluster
    end
  end

  describe '#create' do
    let(:path) {'/v2/databases'}

    context 'for a successful create' do
      it 'returns a created database cluster' do
        database = DropletKit::DatabaseCluster.new(
          name: "backend",
          engine: "pg",
          version: "10",
          tags: ["production"],
          size: "db-s-2vcpu-4gb",
          region: "nyc3",
          num_nodes: 2,
        )

        as_string = DropletKit::DatabaseClusterMapping.representation_for(:create, database)
        request = stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('databases/create_response'), status: 201)
        created_database = resource.create(database)

        expect(created_database).to match_database_cluster
        expect(request).to have_been_made
      end
    end
  end
  
  describe '#delete' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}" }

    it 'sends a delete request for the volume' do  
      request = stub_do_api(path, :delete).to_return(status: 204)
      resource.delete(id: database_id)

      expect(request).to have_been_made
    end
  end

  describe '#migrate' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}" }

    context 'for a successful migration' do
      it 'returns an accepted response' do
        database = DropletKit::DatabaseCluster.new(
          region: "sfo2",
        )

        as_string = DropletKit::DatabaseClusterMapping.representation_for(:update, database)
        request = stub_do_api(path, :put).with(body: as_string).to_return(status: 202)
        resource.migrate(database, id: database_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#resize' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}" }

    context 'for a successful migration' do
      it 'returns an accepted response' do
        database = DropletKit::DatabaseCluster.new(
          num_nodes: 3,
          size: "db-s-4vcpu-8gb",
        )

        as_string = DropletKit::DatabaseClusterMapping.representation_for(:update, database)
        request = stub_do_api(path, :put).with(body: as_string).to_return(status: 202)
        resource.resize(database, id: database_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#list_backups' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/backups" }

    it 'returns all of the database cluster\'s backups' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_backups_response'), status: 200)
      database_cluster_backups = resource.list_backups(id: database_id)

      expect(database_cluster_backups).to all(be_kind_of(DropletKit::DatabaseClusterBackup))
      expect(database_cluster_backups.first).to match_database_cluster_backup
      expect(request).to have_been_made
    end
  end

  describe '#restore_backup' do
    let(:path) {'/v2/databases'}

    context 'for a successful backup restore' do
      it 'returns a newly created database cluster from the backup' do
        backup_restore = DropletKit::DatabaseClusterRestoreBackup.new(
          name: "backend-restored",
          engine: "pg",
          version: "10",
          size: "db-s-2vcpu-4gb",
          region: "nyc3",
          num_nodes: 2,
          backup_restore: DropletKit::DatabaseClusterBackupRestore.new(
            name: "backend",
            created_at: "2019-01-11T18:37:36Z",
          ),
        )

        as_string = DropletKit::DatabaseClusterRestoreBackupMapping.representation_for(:create, backup_restore)
        request = stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('databases/restore_from_backup_response'), status: 201)
        restored_database = resource.restore_from_backup(backup_restore)

        expect(restored_database).to be_kind_of(DropletKit::DatabaseCluster)
        expect(restored_database.id).to eq("9423cbad-9211-442f-820b-ef6915e99b5f")
        expect(restored_database.name).to eq("backend-restored")
        expect(restored_database.engine).to eq("pg")
        expect(restored_database.version).to eq("10")
        expect(restored_database.region).to eq("nyc3")
        expect(restored_database.size).to eq("db-s-2vcpu-4gb")
        expect(restored_database.created_at).to eq("2019-01-11T18:37:36Z")
        expect(request).to have_been_made
      end
    end
  end

  describe '#set_maintenance_window' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/maintenance" }

    context 'for a successful maintenance window configuration' do
      it 'returns a no content response' do
        maintenance_window = DropletKit::DatabaseClusterMaintenanceWindow.new(
          day: "tuesday",
          hour: "14:00",
        )

        as_string = DropletKit::DatabaseClusterMaintenanceWindowMapping.representation_for(:update, maintenance_window)
        request = stub_do_api(path, :put).with(body: as_string).to_return(status: 204)
        resource.set_maintenance_window(maintenance_window, id: database_id)
        
        expect(request).to have_been_made
      end
    end
  end

  describe '#list_firewall_rules' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/firewall" }

    it 'returns all of the database cluster\'s firewall rules' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_firewall_rules_response'), status: 200)
      database_cluster_firewall_rules = resource.list_firewall_rules(id: database_id)

      expect(database_cluster_firewall_rules).to all(be_kind_of(DropletKit::DatabaseClusterFirewallRules))
      expect(database_cluster_firewall_rules.first.uuid).to eq("79f26d28-ea8a-41f2-8ad8-8cfcdd020095")
      expect(database_cluster_firewall_rules.first.type).to eq("k8s")
      expect(database_cluster_firewall_rules.first.value).to eq("ff2a6c52-5a44-4b63-b99c-0e98e7a63d61")
      expect(database_cluster_firewall_rules.first.created_at).to eq("2019-11-14T20:30:28Z")
      expect(request).to have_been_made
    end
  end

  describe '#set_firewall_rules' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/firewall" }

    context 'for a successful firewall rules configuration' do
      it 'returns a no content response' do
        firewall_rules = [
          DropletKit::DatabaseClusterFirewallRules.new(
            type: "ip_addr",
            value: "192.168.1.1",
          ),
          DropletKit::DatabaseClusterFirewallRules.new(
            type: "k8s",
            value: "ff2a6c52-5a44-4b63-b99c-0e98e7a63d61",
          ),
        ]

        as_string = DropletKit::DatabaseClusterFirewallRulesMapping.represent_collection_for(:update, firewall_rules)
        request = stub_do_api(path, :put).with(body: as_string).to_return(status: 204)
        resource.set_firewall_rules(firewall_rules, id: database_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#create_read_only_replica' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/replicas" }

    context 'for a successful read only replica creation' do
      it 'returns a newly created database replica' do
        database_replica = DropletKit::DatabaseCluster.new(
          name: "read-nyc3-01",
          size: "db-s-2vcpu-4gb",
          region: "nyc3",
        )

        as_string = DropletKit::DatabaseClusterMapping.representation_for(:create, database_replica)

        request = stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('databases/create_read_only_replica_response'), status: 201)
        read_only_replica = resource.create_read_only_replica(database_replica, id: database_id)

        expect(read_only_replica.replica).to match_read_only_database_cluster_replica
        expect(request).to have_been_made
      end
    end
  end

  describe '#list_read_only_replicas' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/replicas" }

    it 'returns all of the database cluster\'s read_only_replicas' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_read_only_replica_response'), status: 200)
      database_cluster_read_only_replicas = resource.list_read_only_replicas(id: database_id)

      expect(database_cluster_read_only_replicas.replicas).to all(be_kind_of(DropletKit::DatabaseCluster))
      expect(database_cluster_read_only_replicas.replicas.first).to match_read_only_database_cluster_replica
      expect(request).to have_been_made
    end
  end

  describe '#delete_read_only_replica' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:replica_name) { "read-nyc3-01" }
    let(:path) { "/v2/databases/#{database_id}/replicas/#{replica_name}" }

    it 'sends a delete request for the volume' do  
      request = stub_do_api(path, :delete).to_return(status: 204)
      resource.delete_read_only_replica(id: database_id, name: replica_name)

      expect(request).to have_been_made
    end
  end

  describe '#create_database_user' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/users" }

    context 'for a successful create of a database user' do
      it 'returns a created database cluster user' do
        database_user = DropletKit::DatabaseClusterUser.new(
          name: "app-01",
        )

        as_string = DropletKit::DatabaseClusterUserMapping.representation_for(:create, database_user)
        request = stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('databases/create_database_user_response'), status: 201)
        created_database_user = resource.create_database_user(database_user, id: database_id)
        
        expect(created_database_user).to match_cluster_user
        expect(request).to have_been_made
      end
    end
  end

  describe '#find_database_user' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:name) { "app-01" }
    let(:path) { "/v2/databases/#{database_id}/users/#{name}" }

    it 'retrieves the proper database user' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/get_database_user_response'), status: 200)
      database_user = resource.find_database_user(id: database_id, name: name)
      
      expect(database_user).to match_cluster_user
      expect(request).to have_been_made
    end
  end
  
  describe '#list_database_users' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/users" }

    it 'retrieves all database users' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_database_user_response'), status: 200)
      database_user = resource.list_database_users(id: database_id)
      
      expect(database_user).to all(be_kind_of(DropletKit::DatabaseClusterUser))
      expect(database_user.first).to match_cluster_user
      expect(request).to have_been_made
    end
  end

  describe '#delete_database_user' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:name) { "app-01" }
    let(:path) { "/v2/databases/#{database_id}/users/#{name}" }

    it 'retrieves the proper database user' do
      request = stub_do_api(path, :delete).to_return(status: 204)
      database_user = resource.delete_database_user(id: database_id, name: name)

      expect(request).to have_been_made
    end
  end

  describe '#create_database' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/dbs" }

    context 'for a successful create of a database' do
      it 'returns a created database' do
        database = DropletKit::Database.new(
          name: "alpha",
        )

        as_string = DropletKit::DatabaseMapping.representation_for(:create, database)
        request = stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('databases/create_database_response'), status: 201)
        created_database = resource.create_database(database, id: database_id)
        
        expect(created_database).to match_database
        expect(request).to have_been_made
      end
    end
  end

  describe '#find_database' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:database_name) { "alpha" }
    let(:path) { "/v2/databases/#{database_id}/dbs/#{database_name}" }

    it 'returns a logical database' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/get_database_response'), status: 200)
      database = resource.find_database(name: database_name, id: database_id)
      
      expect(database).to match_database
      expect(request).to have_been_made
    end
  end

  describe '#list_databases' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/dbs" }

    it 'returns all logical databases' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_databases_response'), status: 200)
      database = resource.list_databases(id: database_id)
      
      expect(database).to all(be_kind_of(DropletKit::Database))
      expect(database.first).to match_database
      expect(request).to have_been_made
    end
  end

  describe '#delete_database' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:database_name) { "alpha" }
    let(:path) { "/v2/databases/#{database_id}/dbs" }

    it 'deletes the logical database' do
      request = stub_do_api(path, :delete).to_return(status: 204)
      database = resource.delete_database(id: database_id, name: database_name)
      
      expect(request).to have_been_made
    end
  end

  describe '#create_connection_pool' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/pools" }

    context 'for a successful create of a database connection pool' do
      it 'returns a created database connection pool' do
        database_connection_pool = DropletKit::DatabaseClusterConnectionPool.new(
          name: "backend-pool",
          mode: "transaction",
          size: 10,
          db: "defaultdb",
          user: "doadmin",
        )

        as_string = DropletKit::DatabaseClusterConnectionPoolMapping.representation_for(:create, database_connection_pool)
        request = stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('databases/create_connection_pool_response'), status: 201)
        created_database_connection_pool = resource.create_connection_pool(database_connection_pool, id: database_id)
        
        expect(created_database_connection_pool).to match_database_connection_pool
        expect(request).to have_been_made
      end
    end
  end

  describe '#find_connection_pool' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:connection_pool_name) { "backend-pool" }
    let(:path) { "/v2/databases/#{database_id}/pools/#{connection_pool_name}" }

    it 'returns the database connection pool' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/get_connection_pool_response'), status: 200)
      database_connection_pool = resource.find_connection_pool(id: database_id, name: connection_pool_name)
      
      expect(database_connection_pool).to match_database_connection_pool
      expect(request).to have_been_made
    end
  end

  describe '#list_connection_pool' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/pools" }

    it 'returns all database connection pools' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/list_connection_pools_response'), status: 200)
      database_connection_pool = resource.list_connection_pools(id: database_id)
      
      expect(database_connection_pool).to all(be_kind_of(DropletKit::DatabaseClusterConnectionPool))
      expect(database_connection_pool.first).to match_database_connection_pool
      expect(request).to have_been_made
    end
  end

  describe '#delete_connection_pool' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:connection_pool_name) { "backend-pool" }
    let(:path) { "/v2/databases/#{database_id}/pools" }

    it 'deletes the database connection' do
      request = stub_do_api(path, :delete).to_return(status: 204)
      database_connection_pool = resource.delete_connection_pool(id: database_id, name: connection_pool_name)
      
      expect(request).to have_been_made
    end
  end

  describe '#set_eviction_policy' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/eviction_policy" }

    context 'for a successful eviction policy configuration' do
      it 'returns a no content response' do
        eviction_policy = DropletKit::DatabaseClusterEvictionPolicy.new(
          eviction_policy: "allkeys_lru",
        )

        as_string = DropletKit::DatabaseClusterEvictionPolicyMapping.representation_for(:update, eviction_policy)
        request = stub_do_api(path, :put).with(body: as_string).to_return(status: 204)
        resource.set_eviction_policy(eviction_policy, id: database_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#get_eviction_policy' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/eviction_policy" }

    it 'returns the eviction policy' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/get_eviction_policy_response'),status: 200)
      eviction_policy = resource.get_eviction_policy(id: database_id)

      expect(eviction_policy).to be_kind_of(DropletKit::DatabaseClusterEvictionPolicy)
      expect(eviction_policy.eviction_policy).to eq("allkeys_lru")
      expect(request).to have_been_made
    end
  end

  describe '#set_sql_mode' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/sql_mode" }

    context 'for a successful eviction policy configuration' do
      it 'returns a no content response' do
        sql_mode = DropletKit::DatabaseClusterSQLMode.new(
          sql_mode: "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES",
        )

        as_string = DropletKit::DatabaseClusterSQLModeMapping.representation_for(:update, sql_mode)
        request = stub_do_api(path, :put).with(body: as_string).to_return(status: 204)
        resource.set_sql_mode(sql_mode, id: database_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#get_sql_mode' do
    let(:database_id) { "9cc10173-e9ea-4176-9dbc-a4cee4c4ff30" }
    let(:path) { "/v2/databases/#{database_id}/sql_mode" }

    it 'returns the eviction policy' do
      request = stub_do_api(path, :get).to_return(body: api_fixture('databases/get_sql_modes_response'),status: 200)
      sql_mode = resource.get_sql_mode(id: database_id)

      expect(sql_mode).to be_kind_of(DropletKit::DatabaseClusterSQLMode)
      expect(sql_mode.sql_mode).to eq("ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES")
      expect(request).to have_been_made
    end
  end
end