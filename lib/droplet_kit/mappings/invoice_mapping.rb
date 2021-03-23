module DropletKit
  class InvoiceMapping
    include Kartograph::DSL

    kartograph do
      mapping Invoice
      root_key plural: 'invoices', scopes: [:read]
      root_key plural: 'invoice_items', scopes: [:find]

      scoped :read do
        property :invoice_uuid
        property :amount
        property :invoice_period
      end

      scoped :find do
        property :product
        property :amount
        property :resource_uuid
        property :group_description
        property :description
        property :duration
        property :duration_unit
        property :start_time
        property :end_time
        property :project_name
        property :category
      end
    end
  end
end
  