require 'spec_helper'

RSpec.describe DropletKit::DomainResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all of the domains' do
      response = api_fixture('domains/all')
      stub_do_api('/v2/domains', :get).to_return(body: response)
      expected_domains = DropletKit::DomainMapping.extract_collection(response, :read)

      expect(resource.all).to eq(expected_domains)
    end
  end
end