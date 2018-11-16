module DropletKit
  class KubernetesResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/kubernetes/clusters' do
        handler(200) { |response| KubernetesMapping.extract_collection(response.body, :read) }
      end
    end

    #
    # def all(*args)
    #   PaginatedResource.new(action(:all), self, *args)
    # end
  end
end
