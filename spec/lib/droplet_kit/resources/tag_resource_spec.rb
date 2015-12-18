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

      expect(tags.first).to match_tag_fixture
    end

    context 'when empty' do
      it 'returns an empty array of tags' do
        stub_do_api('/v2/tags', :get)
          .to_return(body: api_fixture('tags/all_empty'))
        tags = resource.all.map(&:name)

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

  describe '#update' do
    it 'updateds a tag' do
      tag = DropletKit::Tag.new(name: 'testing-1')
      as_hash = DropletKit::TagMapping.hash_for(:update, tag)

      request = stub_do_api('/v2/tags/old-testing-1', :put)
        .with(body: DropletKit::TagMapping.representation_for(:update, tag))
        .to_return(body: api_fixture('tags/find'))

      tag = resource.update(tag, name: 'old-testing-1')
      expect(request).to have_been_made
      expect(tag.name).to eq('testing-1')
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

  describe '#add' do
    it 'adds a tag' do
      params = {
        resource_id: '1',
        resource_type: "droplet"
      }

      request = stub_do_api('/v2/tags/testing-1/add', :post)
        .with(body: params.to_json)
        .to_return(body: '', status: 204)

      resource.add(params.merge(name: 'testing-1'))

      expect(request).to have_been_made
    end
  end

  describe '#remove' do
    it 'removes a tag' do
      params = {
        resource_id: '1',
        resource_type: "droplet"
      }

      request = stub_do_api('/v2/tags/testing-1/remove', :post)
        .with(body: params.to_json)
        .to_return(body: '', status: 204)

      resource.remove(params.merge(name: 'testing-1'))

      expect(request).to have_been_made
    end
  end
end
