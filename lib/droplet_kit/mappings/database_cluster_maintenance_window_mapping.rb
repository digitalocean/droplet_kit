module DropletKit
  class DatabaseClusterMaintenanceWindowMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterMaintenanceWindow

      scoped :read, :update do
        property :day
        property :hour
      end

      scoped :read do
        property :pending
        property :description
      end
    end
  end
end