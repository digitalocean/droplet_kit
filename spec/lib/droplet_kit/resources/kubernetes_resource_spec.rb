require 'spec_helper'

RSpec.describe DropletKit::KubernetesResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#config' do
    it 'returns a yaml string kubeconfig' do
      response = Pathname.new('./spec/fixtures/kubernetes/clusters/kubeconfig.txt').read

      stub_do_api('/v2/kubernetes/clusters/1/kubeconfig', :get).to_return(body: response)

      config = resource.config(id: '1')

      expect(config).to be_kind_of(String)

      parsed_config = YAML.load(config)
      expect(parsed_config.keys).to match_array(["apiVersion", "clusters", "contexts", "current-context", "kind", "preferences", "users"])
    end
  end
end
