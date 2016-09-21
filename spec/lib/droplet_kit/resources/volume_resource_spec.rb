require 'spec_helper'

RSpec.describe DropletKit::VolumeResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_volume_fixture do
    match do |volume|
      expect(volume).to be_kind_of(DropletKit::Volume)

      expect(volume.region).to be_kind_of(DropletKit::Region)
      expect(volume.id).to eq("7724db7c-e098-11e5-b522-000f53304e51")
      expect(volume.droplet_ids).to eq([])
      expect(volume.name).to eq("Example")
      expect(volume.description).to eq("Block store for examples")
      expect(volume.size_gigabytes).to eq(10)
      expect(volume.created_at).to eq("2016-03-02T17:00:49Z")
    end
  end

  describe '#all' do
    it 'returns all of the volumes' do
      stub_do_api('/v2/volumes', :get).to_return(body: api_fixture('volumes/all'))
      volumes = resource.all

      expect(volumes).to all(be_kind_of(DropletKit::Volume))
      expect(volumes.first).to match_volume_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'volumes/all' }
      let(:api_path) { '/v2/volumes' }
    end
  end

  describe '#find' do
    it 'returns a singular volume' do
      stub_do_api('/v2/volumes/7724db7c-e098-11e5-b522-000f53304e51', :get).to_return(body: api_fixture('volumes/find'))
      volume = resource.find(id: "7724db7c-e098-11e5-b522-000f53304e51")

      expect(volume).to match_volume_fixture
    end
  end

  describe '#create' do
    let(:path) { '/v2/volumes' }

    context 'for a successful create' do
      it 'returns the created volume' do
        volume = DropletKit::Volume.new(
          size_gigabytes: 10,
          name: "Example",
          description: "Block store for examples",
          region: "nyc1"
        )

        as_string = DropletKit::VolumeMapping.representation_for(:create, volume)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('volumes/create'), status: 201)
        created_volume = resource.create(volume)

        expect(created_volume).to match_volume_fixture
      end
    end

    context 'with a snapshot id' do
      it 'returns the created volume' do
        volume = DropletKit::Volume.new(
          size_gigabytes: 10,
          name: "Example",
          description: "Block store for examples",
          snapshot_id: "7724db7c-e098-11e5-b522-000f53304e51"
        )

        as_string = DropletKit::VolumeMapping.representation_for(:create, volume)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('volumes/create'), status: 201)
        created_volume = resource.create(volume)

        expect(created_volume).to match_volume_fixture
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::Volume.new }
    end
  end

  describe '#create_snapshot' do
    let(:id) { '7724db7c-e098-11e5-b522-000f53304e51' }
    let(:path) { "/v2/volumes/#{id}/snapshot" }

    context 'for a successful create' do
      it 'returns the created volume' do
        as_string = { name: 'foo' }.to_json
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('volumes/create_snapshot'), status: 201)
        created_snapshot = resource.create_snapshot(id: id, name: 'foo')

        expect(created_snapshot).to be_kind_of(DropletKit::Snapshot)

        expect(created_snapshot.id).to eq("7724db7c-e098-11e5-b522-000f53304e51")
        expect(created_snapshot.name).to eq("Ubuntu Foo")
        expect(created_snapshot.regions).to eq(["nyc1"])
        expect(created_snapshot.resource_type).to eq("volume")
        expect(created_snapshot.resource_id).to eq("7724db7c-e098-11e5-b522-000f53304e51")
        expect(created_snapshot.min_disk_size).to eq(10)
        expect(created_snapshot.size_gigabytes).to eq(0.4)
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create_snapshot' }
      let(:arguments) { { id: id } }
    end
  end

  describe '#delete' do
    it 'sends a delete request for the volume' do
      request = stub_do_api('/v2/volumes/7724db7c-e098-11e5-b522-000f53304e51', :delete)
      resource.delete(id: "7724db7c-e098-11e5-b522-000f53304e51")

      expect(request).to have_been_made
    end
  end
end