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
    expect(droplet.created_at).to eq('2014-07-29T14:35:36Z')

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
  end

  describe '#all' do
    it 'returns all of the droplets' do
      stub_do_api('/v2/droplets', :get).to_return(body: api_fixture('droplets/all'))
      droplets = resource.all
      expect(droplets).to all(be_kind_of(DropletKit::Droplet))

      check_droplet(droplets[0])
    end
  end
end