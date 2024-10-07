# frozen_string_literal: true

module DropletKit
  class OneClickResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :all, 'GET /v2/1-clicks' do
        query_keys :type

        handler(200) do |response|
          OneClickMapping.extract_collection(response.body, :read)
        end
      end

      action :create_kubernetes, 'POST /v2/1-clicks/kubernetes' do
        body { |object| OneClickKubernetesMapping.representation_for(:create, object) }

        handler(200) { |response| response.body }
      end
    end
  end
end
