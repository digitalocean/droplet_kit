require 'spec_helper'

RSpec.describe DropletKit::InvoiceResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#invoices' do
    it 'returns the invoices about the current user' do
      invoices_json = api_fixture('invoice/list')
      stub_do_api('/v2/customers/my/invoices', :get).to_return(body: invoices_json)
      expected_data = DropletKit::InvoiceMapping.extract_collection invoices_json, :read

      expect(resource.list).to eq(expected_data)
    end
    
    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/customers/my/invoices' }
      let(:method) { :get }
      let(:action) { :list }
    end
  end
end
