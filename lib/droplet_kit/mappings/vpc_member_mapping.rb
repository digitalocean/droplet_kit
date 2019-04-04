module DropletKit
  class VPCMemberMapping
    include Kartograph::DSL

    kartograph do
      mapping VPCMember
      root_key plural: 'members', scopes: [:read]

      scoped :read do
        property  :urn
        property  :name
        property  :created_at
      end
    end
  end
end