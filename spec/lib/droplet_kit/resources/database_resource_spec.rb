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
      database_clusters = resource.all_clusters()
      expect(database_clusters).to all(be_kind_of(DropletKit::DatabaseCluster))

      database_cluster = database_clusters.first
      expect(database_cluster).to match_database_cluster
    end

    it 'returns an empty array of database clusters' do
      stub_do_api('/v2/databases', :get).to_return(body: api_fixture('databases/all_clusters_empty'))
      database_clusters = resource.all_clusters()
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
      request = stub_do_api("/v2/databases/#{database_cluster_id}/resize", :put).with(body: json_body).to_return(status: 202)

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
      request = stub_do_api("/v2/databases/#{database_cluster_id}/migrate", :put).with(body: json_body).to_return(status: 202)

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
end
