require 'spec_helper'

RSpec.describe DropletKit::KubernetesResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#delete' do
    it 'sends a delete request for a cluster' do
      request = stub_do_api('/v2/kubernetes/clusters/23', :delete).to_return(status: 202)
      response = resource.delete(id: 23)

      expect(request).to have_been_made
      expect(response).to eq(true)
    end
  end
end
