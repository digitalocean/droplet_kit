require 'spec_helper'

RSpec.describe DropletKit::ImageActionResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  describe '#transfer' do
    it 'sends a transfer request for an image' do

    end
  end
end