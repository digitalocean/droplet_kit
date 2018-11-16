module DropletKit
  class Kubernetes < BaseModel
    [:id, :name, :region].each do |key|
      attribute(key)
    end
  end
end
