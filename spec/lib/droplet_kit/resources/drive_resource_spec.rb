require 'spec_helper'

RSpec.describe DropletKit::DriveResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  RSpec::Matchers.define :match_drive_fixture do
    match do |drive|
      expect(drive).to be_kind_of(DropletKit::Drive)

      expect(drive.region).to be_kind_of(DropletKit::Region)
      expect(drive.id).to eq("7724db7c-e098-11e5-b522-000f53304e51")
      expect(drive.droplet_ids).to eq([])
      expect(drive.name).to eq("Example")
      expect(drive.description).to eq("Block store for examples")
      expect(drive.size_gigabytes).to eq(10)
      expect(drive.created_at).to eq("2016-03-02T17:00:49Z")
    end
  end

  describe '#all' do
    it 'returns all of the drives' do
      stub_do_api('/v2/drives', :get).to_return(body: api_fixture('drives/all'))
      drives = resource.all

      expect(drives).to all(be_kind_of(DropletKit::Drive))
      expect(drives.first).to match_drive_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'drives/all' }
      let(:api_path) { '/v2/drives' }
    end
  end

  describe '#find' do
    it 'returns a singular drive' do
      stub_do_api('/v2/drives/7724db7c-e098-11e5-b522-000f53304e51', :get).to_return(body: api_fixture('drives/find'))
      drive = resource.find(id: "7724db7c-e098-11e5-b522-000f53304e51")

      expect(drive).to match_drive_fixture
    end
  end

  describe '#create' do
    let(:path) { '/v2/drives' }

    context 'for a successful create' do
      it 'returns the created drive' do
        drive = DropletKit::Drive.new(
          size_gigabytes: 10,
          name: "Example",
          description: "Block store for examples",
          region: "nyc1"
        )

        as_string = DropletKit::DriveMapping.representation_for(:create, drive)
        stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('drives/create'), status: 201)
        created_drive = resource.create(drive)

        expect(created_drive).to match_drive_fixture
      end
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::Drive.new }
    end
  end

  describe '#delete' do
    it 'sends a delete request for the drive' do
      request = stub_do_api('/v2/drives/7724db7c-e098-11e5-b522-000f53304e51', :delete)
      resource.delete(id: "7724db7c-e098-11e5-b522-000f53304e51")

      expect(request).to have_been_made
    end
  end
end