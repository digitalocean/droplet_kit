module DropletKit
  class ProjectResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/projects' do
        query_keys :per_page, :page
        handler(200) { |response| ProjectMapping.extract_collection(response.body, :read) }
      end

      action :find_default, 'GET /v2/projects/default' do
        handler(200) { |response| ProjectMapping.extract_single(response.body, :read) }
      end

      action :find, 'GET /v2/projects/:id' do
        handler(200) { |response| ProjectMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/projects' do
        body { |project| ProjectMapping.representation_for(:create, project) }
        handler(201) { |response| ProjectMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update, 'PUT /v2/projects/:id' do
        body { |project| ProjectMapping.representation_for(:update, project) }
        handler(200) { |response| ProjectMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :delete, 'DELETE /v2/projects/:id' do
        handler(204) { |_| true }
        handler(422) { |response| ErrorMapping.fail_with(FailedDelete, response.body) }
      end

      action :list_resources, 'GET /v2/projects/:id/resources' do
        handler(200) { |response| ProjectAssignmentMapping.extract_collection(response.body, :read) }
      end

      action :assign_resources, 'POST /v2/projects/:id/resources' do
        verb :post
        body do |resources|
          { resources: to_urn(resources).compact }.to_json
        end
        handler(200) { |response| ProjectAssignmentMapping.extract_collection(response.body, :read) }

        def to_urn(resources)
          resources.to_a.map do |resource|
            if resource.is_a?(String) && DropletKit::BaseModel.valid_urn?(resource)
              resource
            elsif resource.try(:urn) && DropletKit::BaseModel.valid_urn?(resource.urn)
              resource.urn
            else
              raise DropletKit::Error.new("cannot assign resource without valid urn: #{resource}")
            end
          end
        end
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
