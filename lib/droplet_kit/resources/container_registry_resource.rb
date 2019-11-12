module DropletKit
    class ContainerRegistryResource < ResourceKit::Resource
      include ErrorHandlingResourcable
  
      resources do
        action :get, 'GET /v2/registry' do
          handler(200) { |response| ContainerRegistryMapping.extract_single(response.body, :read) }
        end
  
        action :create, 'POST /v2/registry' do
          body { |object| ContainerRegistryMapping.representation_for(:create, object) }
          handler(201) { |response, registry| ContainerRegistryMapping.extract_into_object(registry, response.body, :read) }
          handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
        end
  
        action :delete, 'DELETE /v2/registry' do
          handler(204) { |response| true }
        end

        action :docker_credentials, 'GET /v2/registry/docker-credentials' do
          handler(200) { |response| response.body }
        end
      end
    end
end
  