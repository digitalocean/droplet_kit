require 'spec_helper'

RSpec.describe DropletKit::ImageResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all of the images' do
      images_json = api_fixture('images/all')
      stub_do_api('/v2/images', :get).to_return(body: images_json)
      expected_images = DropletKit::ImageMapping.extract_collection images_json, :read

      expect(resource.all).to eq(expected_images)
    end
  end

  describe '#find' do
    it 'returns a singular image' do
      stub_do_api('/v2/images/146', :get).to_return(body: api_fixture('images/find'))
      image = resource.find(id: 146)

      expect(image.id).to eq(449676392)
      expect(image.name).to eq("Ubuntu 13.04")
      expect(image.distribution).to eq(nil)
      expect(image.slug).to eq(nil)
      expect(image.public).to eq(false)
      expect(image.regions).to eq(["region--1"])
    end
  end
end