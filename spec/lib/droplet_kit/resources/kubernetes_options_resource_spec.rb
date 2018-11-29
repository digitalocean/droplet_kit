require 'spec_helper'

RSpec.describe DropletKit::KubernetesOptionsResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe 'all' do
    it 'should get the kubernetes options' do
      stub_do_api("/v2/kubernetes/options", :get).to_return(body: api_fixture('kubernetes/options'))
      options = resource.all
      expect(options).to be_kind_of(DropletKit::KubernetesOptions)
      expect(options.versions.length).to eq 7
      options.versions.each do |version|
        expect(version).to be_kind_of(DropletKit::KubernetesOptionsMapping::Version)
        expect(version.slug).to be_present
        expect(version.kubernetes_version).to be_present
      end
    end
  end
end

