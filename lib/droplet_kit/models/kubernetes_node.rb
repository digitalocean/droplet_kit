# frozen_string_literal: true

module DropletKit
  class KubernetesNode < BaseModel
    %i[id name status created_at updated_at].each do |key|
      attribute(key)
    end
  end
end
