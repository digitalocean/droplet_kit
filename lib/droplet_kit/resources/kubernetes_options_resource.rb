module DropletKit
  class KubernetesOptionsResource < ResourceKit::Resource
    include ErrorHandlingResourcable
    resources do
      action :all, 'GET /v2/kubernetes/options' do
        handler(200) { |response| KubernetesOptionsMapping.extract_single(response.body, :read) }
      end
    end
  end
end
