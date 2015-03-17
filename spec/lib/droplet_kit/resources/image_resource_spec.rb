require 'spec_helper'

RSpec.describe DropletKit::ImageResource do
  subject(:resource) { described_class.new(connection: connection) }
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

      expect(image.id).to eq(146)
      expect(image.name).to eq("Ubuntu 13.04")
      expect(image.distribution).to eq(nil)
      expect(image.slug).to eq(nil)
      expect(image.public).to eq(false)
      expect(image.regions).to eq(["region--1"])
      expect(image.type).to eq("snapshot")
    end
  end

  describe '#delete' do
    it 'deletes an image' do
      request = stub_do_api('/v2/images/146', :delete).to_return(body: '', status: 204)
      resource.delete(id: 146)
      expect(request).to have_been_made
    end
  end

  describe '#update' do
    it 'updates an image' do
      image = DropletKit::Image.new(name: 'new-name')
      as_hash = DropletKit::ImageMapping.representation_for(:update, image, NullHashLoad)
      expect(as_hash[:name]).to eq('new-name')

      request = stub_do_api('/v2/images/146', :put).with(
        body: DropletKit::ImageMapping.representation_for(:update, image)
      ).to_return(body: api_fixture('images/find'))

      image = resource.update(image, id: 146)
      expect(request).to have_been_made

      expect(image).to be_kind_of(DropletKit::Image)
      expect(image.id).to eq(146)
    end
  end
end