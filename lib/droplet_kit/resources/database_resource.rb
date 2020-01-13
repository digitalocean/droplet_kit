module DropletKit
  class DatabaseResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find_cluster, 'GET /v2/databases/:id' do
        handler(200) { |response| DatabaseClusterMapping.extract_single(response.body, :read) }
      end

      action :all_clusters, 'GET /v2/databases' do
        handler(200) { |response| DatabaseClusterMapping.extract_collection(response.body, :read) }
      end

      action :create_cluster, 'POST /v2/databases' do
        body { |object| DatabaseClusterMapping.representation_for(:create, object) }
        handler(201) { |response, database| DatabaseClusterMapping.extract_into_object(database, response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :resize_cluster, 'PUT /v2/databases/:id/resize' do
        body { |object| DatabaseClusterMapping.representation_for(:resize, object) }
        handler(202) { |response| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :migrate_cluster, 'PUT /v2/databases/:id/migrate' do
        body { |object| DatabaseClusterMapping.representation_for(:migrate, object) }
        handler(202) { |response| true }
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
    end
  end
end
