# frozen_string_literal: true

module DropletKit
  class OneClickKubernetesMapping
    include Kartograph::DSL

    kartograph do
      mapping OneClickKubernetes

      scoped :create do
        property :addon_slugs
        property :cluster_uuid
      end
    end
  end
end
