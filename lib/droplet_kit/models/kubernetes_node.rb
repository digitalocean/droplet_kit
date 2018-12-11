module DropletKit
  class KubernetesNode < BaseModel
    [:id, :name, :status, :created_at, :updated_at].each do |key|
      attribute(key)
    end
  end
end
