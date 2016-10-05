module DropletKit
  class ImageMapping
    include Kartograph::DSL

    kartograph do
      mapping Image
      root_key plural: 'images', singular: 'image', scopes: [:read]
      root_key plural: 'snapshots', singular: 'snapshot', scopes: [:read_snapshot]

      property :id, scopes: [:read, :read_snapshot]
      property :name, scopes: [:read, :update, :read_snapshot]
      property :distribution, scopes: [:read, :read_snapshot]
      property :slug, scopes: [:read, :read_snapshot]
      property :public, scopes: [:read, :read_snapshot]
      property :regions, scopes: [:read, :read_snapshot]
      property :type, scopes: [:read, :read_snapshot]
    end
  end
end