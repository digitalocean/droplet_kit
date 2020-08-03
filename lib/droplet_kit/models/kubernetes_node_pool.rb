module DropletKit
  class KubernetesNodePool < BaseModel
    [:id, :name, :size, :count, :tags, :labels, :nodes, :auto_scale, :min_nodes, :max_nodes].each do |key|
      attribute(key)
    end
  end
end
