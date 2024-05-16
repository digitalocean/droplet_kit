# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::BaseModel do # rubocop:todo RSpec/SpecFilePathFormat
  subject(:resource) do
    Class.new(DropletKit::BaseModel) do |base|
      attribute :droplet_limit
      def self.name
        'SomeModel'
      end
    end
  end

  describe '.valid_urn?' do
    it 'is true when there is a constant matching the collection' do
      urn = 'do:droplet:123456'

      expect(described_class.valid_urn?(urn)).to be true
    end

    it 'is true when it is an unsupported collection' do
      urn = 'do:space:234567'

      expect(described_class.valid_urn?(urn)).to be true
    end

    it 'is false when there is no constant matching the name' do
      urn = 'do:whale:345678'

      expect(described_class.valid_urn?(urn)).to be false
    end
  end

  describe '#inspect' do
    it 'returns the information about the current user' do
      instance = resource.new(droplet_limit: 5)
      expect(instance.inspect).to include('<SomeModel')
      expect(instance.inspect).to include('@droplet_limit=>5')
      expect(instance.inspect).to include('<SomeModel {:@droplet_limit=>5}>')
    end
  end
end
