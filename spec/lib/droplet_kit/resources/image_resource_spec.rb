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

    it 'returns private images' do
      images_json = api_fixture('images/private')
      stub_do_api('/v2/images', :get)
        .with(query: hash_including({ private: 'true' }))
        .to_return(body: images_json)
      expected_images = DropletKit::ImageMapping.extract_collection images_json, :read

      expect(resource.all(private: true)).to eq(expected_images)
    end

    it 'returns images of a type' do
      images_json = api_fixture('images/type')
      stub_do_api('/v2/images', :get)
        .with(query: hash_including({ type: 'application' }))
        .to_return(body: images_json)
      expected_images = DropletKit::ImageMapping.extract_collection images_json, :read

      expect(resource.all(type: :application)).to eq(expected_images)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'images/all' }
      let(:api_path) { '/v2/images' }
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

      expect(image.min_disk_size).to eq(20)
      expect(image.size_gigabytes).to eq(0.43)
      expect(image.created_at).to eq('2014-07-29T14:35:41Z')
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/images/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { id: 123 } }
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
      as_hash = DropletKit::ImageMapping.hash_for(:update, image)
      expect(as_hash['name']).to eq('new-name')

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
