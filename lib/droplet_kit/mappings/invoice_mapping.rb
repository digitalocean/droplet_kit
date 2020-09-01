module DropletKit
    class InvoiceMapping
      include Kartograph::DSL
  
      kartograph do
        mapping Invoice
        root_key plural: 'invoices', scopes: [:read]

        scoped :read do
          property :invoice_uuid
          property :amount
          property :invoice_period
        end
      end
    end
  end
  