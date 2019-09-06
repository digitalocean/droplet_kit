module DropletKit
  class KubernetesCluster < BaseModel
    [:id, :name, :region, :version, :auto_upgrade, :cluster_subnet, :service_subnet, :ipv4, :endpoint, :tags, :maintenance_policy, :node_pools, :vpc_uuid].each do |key|
      attribute(key)
    end
  end
end
