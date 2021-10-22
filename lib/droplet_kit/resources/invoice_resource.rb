# frozen_string_literal: true

module DropletKit
  class InvoiceResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :list, 'GET /v2/customers/my/invoices' do
        handler(200) { |response| InvoiceMapping.extract_collection(response.body, :read) }
      end

      action :find, 'GET v2/customers/my/invoices/:id' do
        handler(200) { |response| InvoiceMapping.extract_collection(response.body, :find) }
      end
    end
  end
end
