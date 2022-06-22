# frozen_string_literal: true

module DropletKit
  class BalanceMapping
    include Kartograph::DSL

    kartograph do
      mapping Balance
      property :month_to_date_balance, scopes: [:read]
      property :account_balance, scopes: [:read]
      property :month_to_date_usage, scopes: [:read]
      property :generated_at, scopes: [:read]
    end
  end
end
