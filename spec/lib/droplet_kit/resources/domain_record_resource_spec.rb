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

  describe '#create' do
    it 'creates a domain record' do
      response = api_fixture('domain_records/create')

      domain_record = DropletKit::DomainRecord.new(
        type: 'CNAME',
        name: 'www',
        data: '@'
      )
      as_hash = DropletKit::DomainRecordMapping.representation_for(:create, domain_record, NullHashLoad)
      expect(as_hash[:type]).to eq('CNAME')
      expect(as_hash[:name]).to eq('www')
      expect(as_hash[:data]).to eq('@')

      as_json = DropletKit::DomainRecordMapping.representation_for(:create, domain_record)
      stub_do_api('/v2/domains/example.com/records', :post).with(body: as_json).to_return(body: response, status: 201)

      created_domain_record = resource.create(domain_record, for_domain: 'example.com')
      expect(created_domain_record.id).to eq(16)
      expect(created_domain_record.name).to eq('www')
      expect(created_domain_record.type).to eq('CNAME')
      expect(created_domain_record.data).to eq('@')
    end
  end
end