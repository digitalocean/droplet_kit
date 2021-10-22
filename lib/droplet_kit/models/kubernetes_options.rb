# frozen_string_literal: true

module DropletKit
  class KubernetesOptions < BaseModel
    attribute :versions
    attribute :regions
    attribute :sizes
  end
end
