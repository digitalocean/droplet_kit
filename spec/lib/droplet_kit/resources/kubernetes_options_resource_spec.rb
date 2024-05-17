# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::KubernetesOptionsResource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  describe 'all' do
    it 'gets the kubernetes options' do
      stub_do_api('/v2/kubernetes/options', :get).to_return(body: api_fixture('kubernetes/options'))
      options = resource.all
      expect(options).to be_a(DropletKit::KubernetesOptions)
      expect(options.versions.length).to eq 9
      options.versions.each do |version|
        expect(version).to be_a(DropletKit::KubernetesOptionsMapping::Version)
        expect(version.slug).to be_present
        expect(version.kubernetes_version).to be_present
        expect(version.supported_features).to be_present
      end
      expect(options.regions.length).to eq 13
      options.regions.each do |region|
        expect(region).to be_a(DropletKit::KubernetesOptionsMapping::Region)
        expect(region.name).to be_present
        expect(region.slug).to be_present
      end
      expect(options.sizes.length).to eq 13
      options.sizes.each do |size|
        expect(size).to be_a(DropletKit::KubernetesOptionsMapping::Size)
        expect(size.name).to be_present
        expect(size.slug).to be_present
      end
    end
  end
end
