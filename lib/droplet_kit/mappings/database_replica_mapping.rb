module DropletKit
  class DatabaseReplicaMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseReplica

      property :replicas, scopes: [:read], plural: true, include: DatabaseClusterMapping
      property :replica, scopes: [:read], plural: false, include: DatabaseClusterMapping
    end
  end
end
