module DropletKit
  class KubernetesNodePool < BaseModel
    [:id, :name, :size, :count, :tags, :nodes].each do |key|
      attribute(key)
    end
  end
end
