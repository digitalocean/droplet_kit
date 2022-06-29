# frozen_string_literal: true

module DropletKit
  class Invoice < BaseModel
    attribute :invoice_uuid
    attribute :amount
    attribute :invoice_period
    attribute :product
    attribute :resource_uuid
    attribute :group_description
    attribute :description
    attribute :duration
    attribute :duration_unit
    attribute :start_time
    attribute :end_time
    attribute :project_name
    attribute :category
  end
end
