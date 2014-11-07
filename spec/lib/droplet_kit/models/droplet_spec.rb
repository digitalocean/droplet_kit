require 'spec_helper'

RSpec.describe DropletKit::Droplet do
  let(:droplet_fixture) { api_fixture('droplets/find') }
  let(:droplet) { DropletKit::DropletMapping.extract_single(droplet_fixture, :read) }

  describe '#public_ip' do
    it 'returns the public IP for ipv4' do
      expect(droplet.public_ip).to eq('10.0.0.19')
    end

    context 'when the droplet does not have an IP yet' do
      it 'returns nil' do
        droplet.networks.v4.clear
        expect(droplet.public_ip).to be_nil
      end
    end
  end

  describe '#private_ip' do
    it 'returns the public IP for ipv6' do
      expect(droplet.private_ip).to eq('2001::13')
    end

    context 'when the droplet does not have ipv6 enabled' do
      it 'returns nil' do
        droplet.networks.v6.clear
        expect(droplet.private_ip).to be_nil
      end
    end
  end
end