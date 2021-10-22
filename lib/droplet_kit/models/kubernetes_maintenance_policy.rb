# frozen_string_literal: true

module DropletKit
  class KubernetesMaintenancePolicy < BaseModel
    attribute :start_time
    attribute :day
  end
end
