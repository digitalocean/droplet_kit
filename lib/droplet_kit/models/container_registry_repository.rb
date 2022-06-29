# frozen_string_literal: true

module DropletKit
  class ContainerRegistryRepository < BaseModel
    %i[registry_name name latest_tag tag_count].each do |key|
      attribute(key)
    end
  end
end
