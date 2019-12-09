module DropletKit
  class DatabaseClusterReplicaMapping
    include Kartograph::DSL

    kartograph do
      mapping DatabaseClusterReplica
      scoped :read do
        property :replicas, plural: true, include: DatabaseClusterMapping
      end
    end
  end
end