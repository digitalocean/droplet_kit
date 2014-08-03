require 'spec_helper'

RSpec.describe DropletKit::DropletResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  # Theres a lot to check
  def check_droplet(droplet)
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

    expect(droplet.size).to be_kind_of(DropletKit::Size)
    expect(droplet.size.slug).to eq("1024mb")
    expect(droplet.size.transfer).to eq(2)
    expect(droplet.size.price_monthly).to eq(10.0)
    expect(droplet.size.price_hourly).to eq(0.01488)

    expect(droplet.networks).to be_kind_of(DropletKit::NetworkHash)
    v4_network = droplet.networks.v4.first
    expect(v4_network.ip_address).to eq('127.0.0.19')
    expect(v4_network.netmask).to eq("255.255.255.0")
    expect(v4_network.gateway).to eq("127.0.0.20")
    expect(v4_network.type).to eq("public")

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

      check_droplet(droplets[0])
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
end