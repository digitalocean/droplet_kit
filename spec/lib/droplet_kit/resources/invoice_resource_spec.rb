# frozen_string_literal: true

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

  describe '#find' do
    it 'returns a Invoice by UUID' do
      invoice_json = api_fixture('invoice/find')
      stub_do_api('/v2/customers/my/invoices/123', :get).to_return(body: invoice_json)
      expected_data = DropletKit::InvoiceMapping.extract_collection invoice_json, :find

      expect(resource.find(id: 123)).to eq(expected_data)
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/customers/my/invoices/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { id: 123 } }
    end
  end
end
