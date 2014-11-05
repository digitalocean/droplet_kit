require 'spec_helper'

RSpec.describe DropletKit::BaseModel do
  subject(:resource) do
    Class.new(DropletKit::BaseModel) do |base|
      attribute :droplet_limit
      def self.name
        'SomeModel'
      end
    end
  end

  describe '#inspect' do
    it 'returns the information about the current user' do
      instance = resource.new(droplet_limit: 5)
      expect(instance.inspect).to include("<SomeModel")
      expect(instance.inspect).to include("@droplet_limit=>5")
      expect(instance.inspect).to include("<SomeModel {:@droplet_limit=>5}>")
    end
  end
end