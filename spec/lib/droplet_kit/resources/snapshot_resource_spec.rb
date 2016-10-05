require 'spec_helper'

RSpec.describe DropletKit::SnapshotResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all of the snapshots' do
      snapshots_json = api_fixture('snapshots/all')
      stub_do_api('/v2/snapshots', :get).to_return(body: snapshots_json)
      expected_snapshots = DropletKit::SnapshotMapping.extract_collection(snapshots_json, :read)

      expect(resource.all).to eq(expected_snapshots)
    end

    it 'returns snapshots of a type' do
      snapshots_json = api_fixture('snapshots/resource_type')
      stub_do_api('/v2/snapshots', :get)
        .with(query: hash_including({ resource_type: 'droplet' }))
        .to_return(body: snapshots_json)
      expected_snapshots = DropletKit::SnapshotMapping.extract_collection(snapshots_json, :read)

      expect(resource.all(resource_type: :droplet)).to eq(expected_snapshots)
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'snapshots/all' }
      let(:api_path) { '/v2/snapshots' }
    end
  end

  describe '#find' do
    it 'returns a singular snapshot' do
      stub_do_api('/v2/snapshots/7724db7c-e098-11e5-b522-000f53304e51', :get).to_return(body: api_fixture('snapshots/find'))
      snapshot = resource.find(id: "7724db7c-e098-11e5-b522-000f53304e51")

      expect(snapshot.id).to eq("7724db7c-e098-11e5-b522-000f53304e51")
      expect(snapshot.name).to eq("Ubuntu Foo")
      expect(snapshot.regions).to eq(["nyc1"])
      expect(snapshot.resource_type).to eq("volume")
      expect(snapshot.resource_id).to eq("7724db7c-e098-11e5-b522-000f53304e51")
      expect(snapshot.min_disk_size).to eq(10)
      expect(snapshot.size_gigabytes).to eq(0.4)
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/snapshots/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { id: 123 } }
    end
  end

  describe '#delete' do
    it 'deletes an snapshot' do
      request = stub_do_api('/v2/snapshots/146', :delete).to_return(body: '', status: 204)
      resource.delete(id: 146)
      expect(request).to have_been_made
    end
  end
end