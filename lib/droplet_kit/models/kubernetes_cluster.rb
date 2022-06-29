# frozen_string_literal: true

module DropletKit
  class KubernetesCluster < BaseModel
    %i[id name region version auto_upgrade cluster_subnet service_subnet ipv4 endpoint tags maintenance_policy node_pools vpc_uuid ha].each do |key|
      attribute(key)
    end
  end
end
