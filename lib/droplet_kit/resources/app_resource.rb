# frozen_string_literal: true

module DropletKit
  class AppResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/apps' do
        query_keys :per_page, :page, :with_projects
        handler(200) { |response| AppMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET /v2/apps/:id' do
        handler(200) { |response| AppMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/apps' do
        body { |app| AppMapping.representation_for(:create, app) }
        handler(200) { |response| AppMapping.extract_single(response.body, :read) }
      end

      action :update, 'PUT /v2/apps/:id' do
        body { |app| AppMapping.representation_for(:update, app) }
        handler(200) { |response| AppMapping.extract_single(response.body, :read) }
      end

      action :delete, 'DELETE /v2/apps/:id' do
        handler(200) { |response| response.body }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
