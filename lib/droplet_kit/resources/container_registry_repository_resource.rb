# frozen_string_literal: true

module DropletKit
  class ContainerRegistryRepositoryResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/registry/:registry_name/repositories' do
        query_keys :per_page, :page
        handler(200) { |response| ContainerRegistryRepositoryMapping.extract_collection(response.body, :read) }
      end

      action :tags, 'GET /v2/registry/:registry_name/repositories/:repository/tags' do
        query_keys :per_page, :page
        handler(200) { |response| DropletKit::ContainerRegistryRepositoryTagMapping.extract_collection(response.body, :read) }
      end

      action :delete_tag, 'DELETE /v2/registry/:registry_name/repositories/:repository/tags/:tag' do
        handler(204) { |response| true }
      end

      action :delete_manifest, 'DELETE /v2/registry/:registry_name/repositories/:repository/digests/:manifest_digest' do
        handler(204) { |response| true }
        handler(400) { |response| ErrorMapping.fail_with(FailedDelete, response.body) }
      end

      action :delete, 'DELETE /v2/registry/:registry_name/repositories/:repository' do
        handler(204) { |response| true }
        handler(400) { |response| ErrorMapping.fail_with(FailedDelete, response.body) }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end

    def tags(*args)
      PaginatedResource.new(action(:tags), self, *args)
    end
  end
end
