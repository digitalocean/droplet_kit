# frozen_string_literal: true

module DropletKit
  class Balance < BaseModel
    attribute :month_to_date_balance
    attribute :account_balance
    attribute :month_to_date_usage
    attribute :generated_at
  end
end
