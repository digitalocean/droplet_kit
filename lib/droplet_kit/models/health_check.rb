module DropletKit
  class HealthCheck < BaseModel
    attribute :protocol
    attribute :port
    attribute :path
    attribute :check_interval_seconds
    attribute :response_timeout_seconds
    attribute :healthy_threshold
    attribute :unhealthy_threshold
  end
end
