module DropletKit
  class ContainerRegistry < BaseModel
    [:name].each do |key|
      attribute(key)
    end
  end
end
