module DropletKit
  class HealthCheckMapping
    include Kartograph::DSL

    kartograph do
      mapping HealthCheck

      scoped :read, :create, :update do
        property :protocol
        property :port
        property :path
        property :check_interval_seconds
        property :response_timeout_seconds
        property :healthy_threshold
        property :unhealthy_threshold
      end
    end
  end
end
