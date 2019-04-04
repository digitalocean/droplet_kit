module DropletKit
  class KubernetesCluster < BaseModel
    [:id, :name, :region, :version, :cluster_subnet, :service_subnet, :ipv4, :endpoint, :tags, :node_pools, :vpc_uuid].each do |key|
      attribute(key)
    end
  end
end
