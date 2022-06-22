# frozen_string_literal: true

module DropletKit
  class BalanceResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      default_handler(:ok) { |r| BalanceMapping.extract_single(r.body, :read) }
      get '/v2/customers/my/balance' => :info
    end
  end
end
