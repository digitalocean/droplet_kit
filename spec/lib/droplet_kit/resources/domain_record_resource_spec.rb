require 'spec_helper'

RSpec.describe DropletKit::DomainRecordResource do
  subject(:resource) { described_class.new(connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns all of the domain records for a domain' do
      response = api_fixture('domain_records/all')
      stub_do_api('/v2/domains/example.com/records', :get).to_return(body: response)

      expected_records = DropletKit::DomainRecordMapping.extract_collection(response, :read)
      returned_records = resource.all(name: 'example.com')

      expect(returned_records).to all(be_kind_of(DropletKit::DomainRecord))
      expect(returned_records).to eq(expected_records)
    end
  end
end