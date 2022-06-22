# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::DatabaseResource do
  subject(:resource) { described_class.new(connection: connection) }

  let(:database_cluster_id) { '9cc10173-e9ea-4176-9dbc-a4cee4c4ff30' }

  include_context 'resources'

  RSpec::Matchers.define :match_database_cluster do
    match do |database_cluster|
      expect(database_cluster).to be_kind_of(DropletKit::DatabaseCluster)
      expect(database_cluster.id).to eq(database_cluster_id)
      expect(database_cluster.name).to eq('backend')
      expect(database_cluster.engine).to eq('pg')
      expect(database_cluster.version).to eq('10')
      expect(database_cluster.num_nodes).to eq(2)
      expect(database_cluster.region).to eq('nyc3')
      expect(database_cluster.created_at).to eq('2019-01-11T18:37:36Z')
      expect(database_cluster.status).to eq('online')
      expect(database_cluster.size).to eq('db-s-2vcpu-4gb')
      expect(database_cluster.tags).to eq(['production'])
      expect(database_cluster.connection.uri).to eq('postgres://doadmin:wv78n3zpz42xezdk@backend-do-user-19081923-0.db.ondigitalocean.com:25060/defaultdb?sslmode=require')
      expect(database_cluster.connection.database).to eq('')
      expect(database_cluster.connection.host).to eq('backend-do-user-19081923-0.db.ondigitalocean.com')
      expect(database_cluster.connection.port).to eq(25060)
      expect(database_cluster.connection.user).to eq('doadmin')
      expect(database_cluster.connection.password).to eq('wv78n3zpz42xezdk')
      expect(database_cluster.connection.ssl).to eq(true)
      expect(database_cluster.private_connection.uri).to eq('postgres://doadmin:wv78n3zpz42xezdk@private-backend-do-user-19081923-0.db.ondigitalocean.com:25060/defaultdb?sslmode=require')
      expect(database_cluster.private_connection.database).to eq('')
      expect(database_cluster.private_connection.host).to eq('private-backend-do-user-19081923-0.db.ondigitalocean.com')
      expect(database_cluster.private_connection.port).to eq(25060)
      expect(database_cluster.private_connection.user).to eq('doadmin')
      expect(database_cluster.private_connection.password).to eq('wv78n3zpz42xezdk')
      expect(database_cluster.private_connection.ssl).to eq(true)
      expect(database_cluster.users.first.name).to eq('doadmin')
      expect(database_cluster.users.first.role).to eq('primary')
      expect(database_cluster.users.first.password).to eq('wv78n3zpz42xezdk')
      expect(database_cluster.db_names).to eq(['defaultdb'])
      expect(database_cluster.maintenance_window.day).to eq('saturday')
      expect(database_cluster.maintenance_window.hour).to eq('08:45:12')
      expect(database_cluster.maintenance_window.pending).to eq(true)
      expect(database_cluster.maintenance_window.description.first).to eq('Update TimescaleDB to version 1.2.1')
      expect(database_cluster.maintenance_window.description.last).to eq('Upgrade to PostgreSQL 11.2 and 10.7 bugfix releases')
    end
  end

  RSpec::Matchers.define :match_read_only_database_cluster_replica do
    match do |cluster|
      expect(cluster).to be_kind_of(DropletKit::DatabaseCluster)
      expect(cluster.name).to eq("read-nyc3-01")
      expect(cluster.region).to eq("nyc3")
      expect(cluster.connection).to be_kind_of(DropletKit::DatabaseConnection)
      expect(cluster.private_connection).to be_kind_of(DropletKit::DatabaseConnection)
    end
  end

  RSpec::Matchers.define :match_cluster_user do
    match do |cluster_user|
      expect(cluster_user).to be_kind_of(DropletKit::DatabaseUser)
      expect(cluster_user.name).to eq("app-01",)
      expect(cluster_user.role).to eq("normal",)
      expect(cluster_user.password).to eq("jge5lfxtzhx42iff")
    end
  end

  RSpec::Matchers.define :match_database_connection_pool do
    match do |pool|
      expect(pool).to be_kind_of(DropletKit::DatabaseConnectionPool)
      expect(pool.user).to eq("doadmin")
      expect(pool.name).to eq("backend-pool")
      expect(pool.size).to eq(10)
      expect(pool.db).to eq("defaultdb")
      expect(pool.mode).to eq("transaction")
      expect(pool.connection).to be_kind_of(DropletKit::DatabaseConnection)
    end
  end

  describe '#find_cluster' do
    it 'finds a database cluster' do
      stub_do_api("/v2/databases/#{database_cluster_id}", :get).to_return(body: api_fixture('databases/find_cluster'))
      database_cluster = resource.find_cluster(id: database_cluster_id)

      expect(database_cluster).to match_database_cluster
    end
  end

  describe '#all_clusters' do
    it 'returns all database clusters' do
      stub_do_api('/v2/databases', :get).to_return(body: api_fixture('databases/all_clusters'))
      database_clusters = resource.all_clusters
      expect(database_clusters).to all(be_kind_of(DropletKit::DatabaseCluster))

      database_cluster = database_clusters.first
      expect(database_cluster).to match_database_cluster
    end

    it 'returns an empty array of database clusters' do
      stub_do_api('/v2/databases', :get).to_return(body: api_fixture('databases/all_clusters_empty'))
      database_clusters = resource.all_clusters
      expect(database_clusters).to be_empty
    end
  end

  describe '#create_cluster' do
    it 'creates a database cluster' do
      database_cluster = DropletKit::DatabaseCluster.new(
        name: 'backend',
        engine: 'pg',
        version: '10',
        region: 'nyc3',
        size: 'db-s-2vcpu-4gb',
        num_nodes: 2,
        tags: ['production']
      )

      as_hash = DropletKit::DatabaseClusterMapping.hash_for(:create, database_cluster)
      expect(as_hash['name']).to eq(database_cluster.name)
      expect(as_hash['engine']).to eq(database_cluster.engine)
      expect(as_hash['version']).to eq(database_cluster.version)
      expect(as_hash['region']).to eq(database_cluster.region)
      expect(as_hash['size']).to eq(database_cluster.size)
      expect(as_hash['num_nodes']).to eq(database_cluster.num_nodes)
      expect(as_hash['tags']).to eq(database_cluster.tags)

      json_body = DropletKit::DatabaseClusterMapping.representation_for(:create, database_cluster)
      stub_do_api('/v2/databases', :post).with(body: json_body).to_return(body: api_fixture('databases/create_cluster'), status: 201)

      created_database_cluster = resource.create_cluster(database_cluster)
      expect(created_database_cluster).to be_kind_of(DropletKit::DatabaseCluster)

      expect(created_database_cluster.id).to eq(database_cluster_id)
      expect(created_database_cluster.name).to eq('backend')
      expect(created_database_cluster.engine).to eq('pg')
      expect(created_database_cluster.version).to eq('10')
      expect(created_database_cluster.num_nodes).to eq(2)
      expect(created_database_cluster.region).to eq('nyc3')
      expect(created_database_cluster.size).to eq('db-s-2vcpu-4gb')
      expect(created_database_cluster.tags).to eq(['production'])
      expect(database_cluster.connection.uri).to eq('postgres://doadmin:wv78n3zpz42xezdk@backend-do-user-19081923-0.db.ondigitalocean.com:25060/defaultdb?sslmode=require')
      expect(database_cluster.connection.database).to eq('')
      expect(database_cluster.connection.host).to eq('backend-do-user-19081923-0.db.ondigitalocean.com')
      expect(database_cluster.connection.port).to eq(25060)
      expect(database_cluster.connection.user).to eq('doadmin')
      expect(database_cluster.connection.password).to eq('wv78n3zpz42xezdk')
      expect(database_cluster.connection.ssl).to eq(true)
      expect(database_cluster.private_connection.uri).to eq('postgres://doadmin:wv78n3zpz42xezdk@private-backend-do-user-19081923-0.db.ondigitalocean.com:25060/defaultdb?sslmode=require')
      expect(database_cluster.private_connection.database).to eq('')
      expect(database_cluster.private_connection.host).to eq('private-backend-do-user-19081923-0.db.ondigitalocean.com')
      expect(database_cluster.private_connection.port).to eq(25060)
      expect(database_cluster.private_connection.user).to eq('doadmin')
      expect(database_cluster.private_connection.password).to eq('wv78n3zpz42xezdk')
      expect(database_cluster.private_connection.ssl).to eq(true)
    end
  end

  describe '#resize_cluster' do
    it 'resizes a database cluster' do
      database_cluster = DropletKit::DatabaseCluster.new(size: 'db-s-4vcpu-8gb', num_nodes: 3)

      as_hash = DropletKit::DatabaseClusterMapping.hash_for(:resize, database_cluster)
      expect(as_hash['size']).to eq(database_cluster.size)
      expect(as_hash['num_nodes']).to eq(database_cluster.num_nodes)

      json_body = DropletKit::DatabaseClusterMapping.representation_for(:resize, database_cluster)
      request = stub_do_api("/v2/databases/#{database_cluster_id}/resize", :put).with(body: json_body).to_return(status: 201)

      resource.resize_cluster(database_cluster, id: database_cluster_id)
      expect(request).to have_been_made
    end
  end

  describe '#migrate_cluster' do
    it 'migrates a database cluster' do
      database_cluster = DropletKit::DatabaseCluster.new(size: 'lon1')

      as_hash = DropletKit::DatabaseClusterMapping.hash_for(:migrate, database_cluster)
      expect(as_hash['region']).to eq(database_cluster.region)

      json_body = DropletKit::DatabaseClusterMapping.representation_for(:migrate, database_cluster)
      request = stub_do_api("/v2/databases/#{database_cluster_id}/migrate", :put).with(body: json_body).to_return(status: 201)

      resource.migrate_cluster(database_cluster, id: database_cluster_id)
      expect(request).to have_been_made
    end
  end

  describe '#update_maintenance_window' do
    it 'sends a requets to update a database maintenance window' do
      database_maintenance_window = DropletKit::DatabaseMaintenanceWindow.new(day: 'tuesday', hour: "14:00")

      as_hash = DropletKit::DatabaseMaintenanceWindowMapping.hash_for(:update, database_maintenance_window)
      expect(as_hash['day']).to eq(database_maintenance_window.day)
      expect(as_hash['hour']).to eq(database_maintenance_window.hour)

      json_body = DropletKit::DatabaseMaintenanceWindowMapping.representation_for(:update, database_maintenance_window)
      request = stub_do_api("/v2/databases/#{database_cluster_id}/maintenance", :put).with(body: json_body).to_return(status: 204)

      resource.update_maintenance_window(database_maintenance_window, id: database_cluster_id)
      expect(request).to have_been_made
    end
  end

  describe '#restore_from_backup' do
    it 'restores a database cluster from a backup' do
      database_backup = DropletKit::DatabaseCluster.new(
        name: 'backend-restored',
        backup_restore: DropletKit::DatabaseBackup.new(
          database_name: 'backend',
          backup_created_at: '2019-01-31T19:25:22Z'
        ),
        engine: 'pg',
        version: '10',
        region: 'nyc3',
        size: 'db-s-2vcpu-4gb',
        num_nodes: 2
      )

      as_hash = DropletKit::DatabaseClusterMapping.hash_for(:restore, database_backup)
      expect(as_hash['name']).to eq(database_backup.name)
      expect(as_hash['engine']).to eq(database_backup.engine)
      expect(as_hash['version']).to eq(database_backup.version)
      expect(as_hash['region']).to eq(database_backup.region)
      expect(as_hash['size']).to eq(database_backup.size)
      expect(as_hash['num_nodes']).to eq(database_backup.num_nodes)
      expect(as_hash['backup_restore']['database_name']).to eq(database_backup.backup_restore.database_name)
      expect(as_hash['backup_restore']['backup_created_at']).to eq(database_backup.backup_restore.backup_created_at)

      json_body = DropletKit::DatabaseClusterMapping.representation_for(:restore, database_backup)
      request = stub_do_api('/v2/databases', :post).with(body: json_body).to_return(body: api_fixture('databases/find_cluster'), status: 201)

      database_cluster = resource.restore_from_backup(database_backup)

      expect(request).to have_been_made
      expect(database_cluster).to be_kind_of(DropletKit::DatabaseCluster)
      expect(database_cluster.id).to eq(database_cluster_id)
      expect(database_cluster.name).to eq('backend')
      expect(database_cluster.engine).to eq('pg')
      expect(database_cluster.version).to eq('10')
      expect(database_cluster.num_nodes).to eq(2)
      expect(database_cluster.region).to eq('nyc3')
      expect(database_cluster.size).to eq('db-s-2vcpu-4gb')
    end
  end

  describe '#delete_cluster' do
    it 'sends a delete request for the database' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}", :delete).to_return(status: 204)
      resource.delete_cluster(id: database_cluster_id)

      expect(request).to have_been_made
    end
  end

  describe '#list_backups' do
    it 'returns all database backups' do
      stub_do_api("/v2/databases/#{database_cluster_id}/backups", :get).to_return(body: api_fixture('databases/backups'), status: 200)
      database_backups = resource.list_backups(id: database_cluster_id)
      expect(database_backups).to all(be_kind_of(DropletKit::DatabaseBackup))

      database_backup = database_backups.first
      expect(database_backup.created_at).to eq('2019-01-11T18:42:27Z')
      expect(database_backup.size_gigabytes).to eq(0.03357696)
    end
  end

  describe '#create_db' do
    it 'creates a database in a cluster' do
      database = DropletKit::Database.new(name: 'alpha')

      as_hash = DropletKit::DatabaseMapping.hash_for(:create, database)
      expect(as_hash['name']).to eq(database.name)

      json_body = DropletKit::DatabaseMapping.representation_for(:create, database)
      request = stub_do_api("/v2/databases/#{database_cluster_id}/dbs", :post).with(body: json_body).to_return(body: api_fixture('databases/database'), status: 201)

      created_db = resource.create_db(database, id: database_cluster_id)

      expect(request).to have_been_made
      expect(created_db).to be_kind_of(DropletKit::Database)
      expect(created_db.name).to eq('alpha')
    end
  end

  describe '#find_db' do
    it 'finds a database by name in a cluster' do
      database_name = 'alpha'

      stub_do_api("/v2/databases/#{database_cluster_id}/dbs/#{database_name}", :get).to_return(body: api_fixture('databases/database'))
      database = resource.find_db(id: database_cluster_id, name: database_name)

      expect(database).to be_kind_of(DropletKit::Database)
      expect(database.name).to eq('alpha')
    end
  end

  describe '#all_dbs' do
    it 'gets all databases in a cluster' do
      stub_do_api("/v2/databases/#{database_cluster_id}/dbs", :get).to_return(body: api_fixture('databases/databases'))
      databases = resource.all_dbs(id: database_cluster_id)

      expect(databases).to all(be_kind_of(DropletKit::Database))
      database = databases.first
      expect(database.name).to eq('alpha')
    end
  end

  describe '#delete_db' do
    it 'sends a delete request for a database in a cluster' do
      database_name = 'alpha'

      request = stub_do_api("/v2/databases/#{database_cluster_id}/dbs/#{database_name}", :delete).to_return(status: 204)
      resource.delete_db(id: database_cluster_id, name: database_name)

      expect(request).to have_been_made
    end
  end

  describe '#set_maintenance_window' do
    context 'for a successful maintenance window configuration' do
      it 'returns a no content response' do
        maintenance_window = DropletKit::DatabaseMaintenanceWindow.new(
          day: "tuesday",
          hour: "14:00",
        )

        json_body = DropletKit::DatabaseMaintenanceWindowMapping.representation_for(:update, maintenance_window)
        request = stub_do_api("/v2/databases/#{database_cluster_id}/maintenance", :put).with(body: json_body).to_return(status: 204)
        resource.set_maintenance_window(maintenance_window, id: database_cluster_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#list_firewall_rules' do
    it 'returns all of the database cluster\'s firewall rules' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/firewall", :get).to_return(body: api_fixture('databases/list_firewall_rules_response'), status: 200)
      database_firewall_rules = resource.list_firewall_rules(id: database_cluster_id)

      expect(database_firewall_rules).to all(be_kind_of(DropletKit::DatabaseFirewallRule))
      expect(database_firewall_rules.first.uuid).to eq("79f26d28-ea8a-41f2-8ad8-8cfcdd020095")
      expect(database_firewall_rules.first.type).to eq("k8s")
      expect(database_firewall_rules.first.value).to eq("ff2a6c52-5a44-4b63-b99c-0e98e7a63d61")
      expect(database_firewall_rules.first.created_at).to eq("2019-11-14T20:30:28Z")
      expect(request).to have_been_made
    end
  end

  describe '#set_firewall_rules' do
    context 'for a successful firewall rules configuration' do
      it 'returns a no content response' do
        firewall_rules = [
          DropletKit::DatabaseFirewallRule.new(
            type: "ip_addr",
            value: "192.168.1.1",
          ),
          DropletKit::DatabaseFirewallRule.new(
            type: "k8s",
            value: "ff2a6c52-5a44-4b63-b99c-0e98e7a63d61",
          ),
        ]

        json_body = DropletKit::DatabaseFirewallRuleMapping.represent_collection_for(:update, firewall_rules)
        request = stub_do_api("/v2/databases/#{database_cluster_id}/firewall", :put).with(body: json_body).to_return(status: 204)
        resource.set_firewall_rules(firewall_rules, id: database_cluster_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#create_read_only_replica' do
    context 'for a successful read only replica creation' do
      it 'returns a newly created database replica' do
        database_replica = DropletKit::DatabaseCluster.new(
          name: "read-nyc3-01",
          size: "db-s-2vcpu-4gb",
          region: "nyc3",
        )

        json_body = DropletKit::DatabaseClusterMapping.representation_for(:create, database_replica)

        request = stub_do_api("/v2/databases/#{database_cluster_id}/replicas", :post).with(body: json_body).to_return(body: api_fixture('databases/create_read_only_replica_response'), status: 201)
        read_only_replica = resource.create_read_only_replica(database_replica, id: database_cluster_id)

        expect(read_only_replica.replica).to match_read_only_database_cluster_replica
        expect(request).to have_been_made
      end
    end
  end

  describe '#list_read_only_replicas' do
    it 'returns all of the database cluster\'s read_only_replicas' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/replicas", :get).to_return(body: api_fixture('databases/list_read_only_replica_response'), status: 200)
      database_cluster_read_only_replicas = resource.list_read_only_replicas(id: database_cluster_id)

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
    context 'for a successful create of a database user' do
      it 'returns a created database cluster user' do
        database_user = DropletKit::DatabaseUser.new(
          name: "app-01",
        )

        json_body = DropletKit::DatabaseUserMapping.representation_for(:create, database_user)
        request = stub_do_api("/v2/databases/#{database_cluster_id}/users", :post).with(body: json_body).to_return(body: api_fixture('databases/create_database_user_response'), status: 201)
        created_database_user = resource.create_database_user(database_user, id: database_cluster_id)

        expect(created_database_user).to match_cluster_user
        expect(request).to have_been_made
      end
    end
  end

  describe '#find_database_user' do
    let(:name) { "app-01" }

    it 'retrieves the proper database user' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/users/#{name}", :get).to_return(body: api_fixture('databases/get_database_user_response'), status: 200)
      database_user = resource.find_database_user(id: database_cluster_id, name: name)

      expect(database_user).to match_cluster_user
      expect(request).to have_been_made
    end
  end

  describe '#list_database_users' do
    it 'retrieves all database users' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/users", :get).to_return(body: api_fixture('databases/list_database_user_response'), status: 200)
      database_user = resource.list_database_users(id: database_cluster_id)

      expect(database_user).to all(be_kind_of(DropletKit::DatabaseUser))
      expect(database_user.first).to match_cluster_user
      expect(request).to have_been_made
    end
  end

  describe '#reset_database_user_auth' do
    database_user = DropletKit::DatabaseUser.new(
      name: "app-01",
      role: "normal",
      password: "jge5lfxtzhx42iff",
      mysql_settings: {
        auth_plugin: "mysql_native_password"
      }
    )

    it 'resets the db user auth' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/users/#{database_user.name}/reset_auth", :post).to_return(body: api_fixture('databases/reset_user_auth_response'), status: 200)
      reset_auth = DropletKit::DatabaseUserResetAuth.new(
        mysql_settings: DropletKit::DatabaseUserMySQLSettings.new(
          auth_plugin: "mysql_native_password"
        )
      )
      resource.reset_database_user_auth(reset_auth, id: database_cluster_id, name: database_user.name)
      expect(database_user).to match_cluster_user
      expect(request).to have_been_made
    end
  end

  describe '#delete_database_user' do
    let(:name) { "app-01" }

    it 'retrieves the proper database user' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/users/#{name}", :delete).to_return(status: 204)
      resource.delete_database_user(id: database_cluster_id, name: name)

      expect(request).to have_been_made
    end
  end

  describe '#create_connection_pool' do
    context 'for a successful create of a database connection pool' do
      it 'returns a created database connection pool' do
        database_connection_pool = DropletKit::DatabaseConnectionPool.new(
          name: "backend-pool",
          mode: "transaction",
          size: 10,
          db: "defaultdb",
          user: "doadmin",
        )

        json_body = DropletKit::DatabaseConnectionPoolMapping.representation_for(:create, database_connection_pool)
        request = stub_do_api("/v2/databases/#{database_cluster_id}/pools", :post).with(body: json_body).to_return(body: api_fixture('databases/create_connection_pool_response'), status: 201)
        created_database_connection_pool = resource.create_connection_pool(database_connection_pool, id: database_cluster_id)

        expect(created_database_connection_pool).to match_database_connection_pool
        expect(request).to have_been_made
      end
    end
  end

  describe '#find_connection_pool' do
    let(:connection_pool_name) { "backend-pool" }

    it 'returns the database connection pool' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/pools/#{connection_pool_name}", :get).to_return(body: api_fixture('databases/get_connection_pool_response'), status: 200)
      database_connection_pool = resource.find_connection_pool(id: database_cluster_id, name: connection_pool_name)

      expect(database_connection_pool).to match_database_connection_pool
      expect(request).to have_been_made
    end
  end

  describe '#list_connection_pool' do
    it 'returns all database connection pools' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/pools", :get).to_return(body: api_fixture('databases/list_connection_pools_response'), status: 200)
      database_connection_pool = resource.list_connection_pools(id: database_cluster_id)

      expect(database_connection_pool).to all(be_kind_of(DropletKit::DatabaseConnectionPool))
      expect(database_connection_pool.first).to match_database_connection_pool
      expect(request).to have_been_made
    end
  end

  describe '#delete_connection_pool' do
    let(:connection_pool_name) { "backend-pool" }

    it 'deletes the database connection' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/pools", :delete).to_return(status: 204)
      resource.delete_connection_pool(id: database_cluster_id, name: connection_pool_name)

      expect(request).to have_been_made
    end
  end

  describe '#set_eviction_policy' do
    context 'for a successful eviction policy configuration' do
      it 'returns a no content response' do
        eviction_policy = DropletKit::DatabaseEvictionPolicy.new(
          eviction_policy: "allkeys_lru",
        )

        json_body = DropletKit::DatabaseEvictionPolicyMapping.representation_for(:update, eviction_policy)
        request = stub_do_api("/v2/databases/#{database_cluster_id}/eviction_policy", :put).with(body: json_body).to_return(status: 204)
        resource.set_eviction_policy(eviction_policy, id: database_cluster_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#get_eviction_policy' do
    it 'returns the eviction policy' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/eviction_policy", :get).to_return(body: api_fixture('databases/get_eviction_policy_response'), status: 200)
      eviction_policy = resource.get_eviction_policy(id: database_cluster_id)

      expect(eviction_policy).to be_kind_of(DropletKit::DatabaseEvictionPolicy)
      expect(eviction_policy.eviction_policy).to eq("allkeys_lru")
      expect(request).to have_been_made
    end
  end

  describe '#set_sql_mode' do
    context 'for a successful eviction policy configuration' do
      it 'returns a no content response' do
        sql_mode = DropletKit::DatabaseSQLMode.new(
          sql_mode: "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES",
        )

        json_body = DropletKit::DatabaseSQLModeMapping.representation_for(:update, sql_mode)
        request = stub_do_api("/v2/databases/#{database_cluster_id}/sql_mode", :put).with(body: json_body).to_return(status: 204)
        resource.set_sql_mode(sql_mode, id: database_cluster_id)

        expect(request).to have_been_made
      end
    end
  end

  describe '#get_sql_mode' do
    it 'returns the eviction policy' do
      request = stub_do_api("/v2/databases/#{database_cluster_id}/sql_mode", :get).to_return(body: api_fixture('databases/get_sql_modes_response'), status: 200)
      sql_mode = resource.get_sql_mode(id: database_cluster_id)

      expect(sql_mode).to be_kind_of(DropletKit::DatabaseSQLMode)
      expect(sql_mode.sql_mode).to eq("ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES")
      expect(request).to have_been_made
    end
  end
end
