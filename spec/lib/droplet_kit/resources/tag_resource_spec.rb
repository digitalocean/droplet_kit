require 'spec_helper'

describe DropletKit::TagResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_tag_fixture do |expected|
    match do |actual|
      expect(actual).to be_kind_of(DropletKit::Tag)
      expect(actual.name).to eq('testing-1')
    end
  end

  describe '#all' do
    it 'returns all of the tags' do
      stub_do_api('/v2/tags', :get)
        .to_return(body: api_fixture('tags/all'))
      tags = resource.all

      expect(tags).to all(be_kind_of(DropletKit::Tag))
      expect(tags[0].name).to eq('testing-1')
      expect(tags[1].name).to eq('testing-2')
    end

    context 'when empty' do
      it 'returns an empty array of tags' do
        stub_do_api('/v2/tags', :get)
          .to_return(body: api_fixture('tags/all_empty'))
        tags = resource.all.map(&:id)

        expect(tags).to be_empty
      end
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'tags/all' }
      let(:api_path) { '/v2/tags' }
    end
  end

  describe '#find' do
    it 'returns a singular tag' do
      stub_do_api('/v2/tags/testing-1', :get)
        .to_return(body: api_fixture('tags/find'))

      tag = resource.find(name: 'testing-1')

      expect(tag).to be_kind_of(DropletKit::Tag)
      expect(tag).to match_tag_fixture
      expect(tag.resources.droplets.count).to eq(1)
      expect(tag.resources.droplets.last_tagged).to be_kind_of(DropletKit::Droplet)
      expect(tag.resources.droplets.last_tagged.id).to eq(1)
    end
  end

  describe '#create' do
    it 'returns the created tag' do
      tag = DropletKit::Tag.new(name: 'testing-1')

      as_string = DropletKit::TagMapping.representation_for(:create, tag)

      stub_do_api('/v2/tags', :post).with(body: as_string)
        .to_return(body: api_fixture('tags/create'), status: 201)
      created_tag = resource.create(tag)

      expect(created_tag).to match_tag_fixture
    end
  end

  describe '#delete' do
    it 'deletes a tag' do
      request = stub_do_api('/v2/tags/testing-1', :delete)
        .to_return(body: '', status: 204)

      resource.delete(name: 'testing-1')
      expect(request).to have_been_made
    end
  end

  describe '#tag_resources' do
    it 'adds a tag' do
      params = {
        resources: [
          {
            resource_id: '1',
            resource_type: "droplet"
          }
        ]
      }

      request = stub_do_api('/v2/tags/testing-1/resources', :post)
        .with(body: params.to_json)
        .to_return(body: '', status: 204)

      resource.tag_resources(params.merge(name: 'testing-1'))

      expect(request).to have_been_made
    end
  end

  describe '#untag_resources' do
    it 'removes a tag' do
      params = {
        resources: [
          {
            resource_id: '1',
            resource_type: "droplet"
          }
        ]
      }

      request = stub_do_api('/v2/tags/testing-1/resources', :delete)
        .with(body: params.to_json)
        .to_return(body: '', status: 204)

      resource.untag_resources(params.merge(name: 'testing-1'))

      expect(request).to have_been_made
    end
  end
end
