# frozen_string_literal: true

module DropletKit
  class ContainerRegistryRepository < BaseModel
    [:registry_name, :name, :latest_tag, :tag_count].each do |key|
      attribute(key)
    end
  end
end
