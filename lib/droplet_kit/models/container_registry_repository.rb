module DropletKit
  class ContainerRegistryRepository < BaseModel
    [:registry_name,:name,:latest_tag].each do |key|
      attribute(key)
    end
  end
end
