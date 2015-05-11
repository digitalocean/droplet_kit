require 'spec_helper'

RSpec.describe DropletKit::DropletResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  # Theres a lot to check
  def check_droplet(droplet)
    expect(droplet.id).to eq(19)
    expect(droplet.name).to eq('test.example.com')
    expect(droplet.memory).to eq(1024)
    expect(droplet.vcpus).to eq(2)
    expect(droplet.disk).to eq(20)
    expect(droplet.locked).to eq(false)
    expect(droplet.status).to eq('active')
    expect(droplet.created_at).to be_present
    expect(droplet.backup_ids).to include(449676382)
    expect(droplet.snapshot_ids).to include(449676383)
    expect(droplet.action_ids).to be_empty
    expect(droplet.features).to include('ipv6')

    expect(droplet.region).to be_kind_of(DropletKit::Region)
    expect(droplet.region.slug).to eq('nyc1')
    expect(droplet.region.name).to eq('New York')
    expect(droplet.region.sizes).to include('1024mb', '512mb')
    expect(droplet.region.available).to be(true)
    expect(droplet.region.features).to include("virtio", "private_networking", "backups", "ipv6")

    expect(droplet.image).to be_kind_of(DropletKit::Image)
    expect(droplet.image.id).to eq(119192817)
    expect(droplet.image.name).to eq("Ubuntu 13.04")
    expect(droplet.image.distribution).to eq("ubuntu")
    expect(droplet.image.slug).to eq("ubuntu1304")
    expect(droplet.image.public).to eq(true)
    expect(droplet.image.regions).to include('nyc1')

    expect(droplet.size_slug).to eq("1024mb")

    expect(droplet.networks).to be_kind_of(DropletKit::NetworkHash)
    private_v4_network = droplet.networks.v4.first
    expect(private_v4_network.ip_address).to eq('10.0.0.19')
    expect(private_v4_network.netmask).to eq("255.255.0.0")
    expect(private_v4_network.gateway).to eq("10.0.0.1")
    expect(private_v4_network.type).to eq("private")

    public_v4_network = droplet.networks.v4.last
    expect(public_v4_network.ip_address).to eq('127.0.0.19')
    expect(public_v4_network.netmask).to eq("255.255.255.0")
    expect(public_v4_network.gateway).to eq("127.0.0.20")
    expect(public_v4_network.type).to eq("public")

    v6_network = droplet.networks.v6.first
    expect(v6_network.ip_address).to eq('2001::13')
    expect(v6_network.gateway).to eq("2400:6180:0000:00D0:0000:0000:0009:7000")
    expect(v6_network.cidr).to eq(124)
    expect(v6_network.type).to eq("public")

    expect(droplet.kernel).to be_kind_of(DropletKit::Kernel)
    expect(droplet.kernel.id).to eq(485432985)
    expect(droplet.kernel.name).to eq("DO-recovery-static-fsck")
    expect(droplet.kernel.version).to eq("3.8.0-25-generic")
  end

  describe '#all' do
    it 'returns all of the droplets' do
      stub_do_api('/v2/droplets', :get).to_return(body: api_fixture('droplets/all'))
      droplets = resource.all
      expect(droplets).to all(be_kind_of(DropletKit::Droplet))

      check_droplet(droplets.first)
    end

    it 'returns an empty array of droplets' do
      stub_do_api('/v2/droplets', :get).to_return(body: api_fixture('droplets/all_empty'))
      droplets = resource.all.map(&:id)
      expect(droplets).to be_empty
    end
  end

  describe '#find' do
    it 'returns a singular droplet' do
      stub_do_api('/v2/droplets/20', :get).to_return(body: api_fixture('droplets/find'))
      droplet = resource.find(id: 20)
      expect(droplet).to be_kind_of(DropletKit::Droplet)
      check_droplet(droplet)
    end
  end

  describe '#create' do
    context 'for a successful create' do
      it 'returns the created droplet' do
        droplet = DropletKit::DropletCreate.new(
          name: 'test.example.com',
          region: 'nyc1',
          size: '512mb',
          image: 'ubuntu-14-04-x86',
          ssh_keys: [123],
          backups: true,
          ipv6: true,
          private_networking: true,
          user_data: "#cloud-config\nruncmd\n\t- echo 'Hello!'"
        )

        as_hash = DropletKit::DropletCreateMapping.representation_for(:create, droplet, NullHashLoad)
        expect(as_hash[:name]).to eq(droplet.name)
        expect(as_hash[:region]).to eq(droplet.region)
        expect(as_hash[:size]).to eq(droplet.size)
        expect(as_hash[:image]).to eq(droplet.image)
        expect(as_hash[:ssh_keys]).to eq(droplet.ssh_keys)
        expect(as_hash[:backups]).to eq(droplet.backups)
        expect(as_hash[:ipv6]).to eq(droplet.ipv6)
        expect(as_hash[:private_networking]).to eq(droplet.private_networking)
        expect(as_hash[:user_data]).to eq(droplet.user_data)

        as_string = DropletKit::DropletCreateMapping.representation_for(:create, droplet)
        stub_do_api('/v2/droplets', :post).with(body: as_string).to_return(body: api_fixture('droplets/create'), status: 202)
        created_droplet = resource.create(droplet)
        check_droplet(created_droplet)
      end
    end

    context 'for an unsuccessful create' do
      it 'raises a FailedCreate exception with the message attached' do
        response_body = { id: :unprocessable_entity, message: 'Something is not right' }
        stub_do_api('/v2/droplets', :post).to_return(body: response_body.to_json, status: 422)

        expect { resource.create(DropletKit::DropletCreate.new) }.to raise_exception(DropletKit::FailedCreate).with_message(response_body[:message])
      end
    end
  end

  describe '#kernels' do
    it 'returns a list of kernels for a droplet' do
      stub_do_api('/v2/droplets/1066/kernels', :get).to_return(body: api_fixture('droplets/list_kernels'))
      kernels = resource.kernels(id: 1066).take(20)

      expect(kernels).to all(be_kind_of(DropletKit::Kernel))
      expect(kernels[0].id).to eq(61833229)
      expect(kernels[0].name).to eq('Ubuntu 14.04 x32 vmlinuz-3.13.0-24-generic')
      expect(kernels[0].version).to eq('3.13.0-24-generic')

      expect(kernels[1].id).to eq(485432972)
      expect(kernels[1].name).to eq('Ubuntu 14.04 x64 vmlinuz-3.13.0-24-generic (1221)')
      expect(kernels[1].version).to eq('3.13.0-24-generic')
    end
  end

  describe '#snapshots' do
    it 'returns a list of kernels for a droplet' do
      stub_do_api('/v2/droplets/1066/snapshots', :get).to_return(body: api_fixture('droplets/list_snapshots'))
      snapshots = resource.snapshots(id: 1066).take(20)

      expect(snapshots).to all(be_kind_of(DropletKit::Snapshot))
      expect(snapshots[0].id).to eq(449676387)
      expect(snapshots[0].name).to eq("Ubuntu 13.04")
      expect(snapshots[0].distribution).to eq("ubuntu")
      expect(snapshots[0].slug).to eq(nil)
      expect(snapshots[0].public).to eq(false)
      expect(snapshots[0].regions).to eq(["nyc1"])
      expect(snapshots[0].created_at).to eq("2014-07-29T14:35:38Z")
    end
  end

  describe '#backups' do
    it 'returns a list of backups for a droplet' do
      stub_do_api('/v2/droplets/1066/backups', :get).to_return(body: api_fixture('droplets/list_backups'))
      backups = resource.backups(id: 1066).take(20)

      expect(backups).to all(be_kind_of(DropletKit::Backup))
      expect(backups[0].id).to eq(449676388)
      expect(backups[0].name).to eq("Ubuntu 13.04")
      expect(backups[0].distribution).to eq("ubuntu")
      expect(backups[0].slug).to eq(nil)
      expect(backups[0].public).to eq(false)
      expect(backups[0].regions).to eq(["nyc1"])
      expect(backups[0].created_at).to eq("2014-07-29T14:35:38Z")
    end
  end

  describe '#actions' do
    it 'returns a list of actions for the droplet' do
      stub_do_api('/v2/droplets/1066/actions', :get).to_return(body: api_fixture('droplets/list_actions'))
      actions = resource.actions(id: 1066).take(20)

      expect(actions).to all(be_kind_of(DropletKit::Action))

      expect(actions[0].id).to eq(19)
      expect(actions[0].status).to eq("in-progress")
      expect(actions[0].type).to eq("create")
      expect(actions[0].started_at).to eq("2014-07-29T14:35:39Z")
      expect(actions[0].completed_at).to eq(nil)
      expect(actions[0].resource_id).to eq(24)
      expect(actions[0].resource_type).to eq("droplet")
      expect(actions[0].region).to be_kind_of(DropletKit::Region)
      expect(actions[0].region.slug).to eq('nyc1')
      expect(actions[0].region.name).to eq('New York')
      expect(actions[0].region.sizes).to include('512mb')
      expect(actions[0].region.available).to be(true)
      expect(actions[0].region.features).to include("virtio", "private_networking", "backups", "ipv6", "metadata")
    end
  end

  describe '#delete' do
    it 'sends a delete request for the droplet' do
      request = stub_do_api('/v2/droplets/1066', :delete)
      resource.delete(id: 1066)

      expect(request).to have_been_made
    end
  end
end
