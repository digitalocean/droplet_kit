# frozen_string_literal: true

module DropletKit
  class ContainerRegistryRepositoryTag < BaseModel
    [:registry_name, :repository, :tag, :manifest_digest, :compressed_size_bytes, :size_bytes, :updated_at].each do |key|
      attribute(key)
    end
  end
end
