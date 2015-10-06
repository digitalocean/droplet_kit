module DropletKit
  class AccountResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      default_handler(:ok) {|r| AccountMapping.extract_single(r.body, :read) }
      get '/v2/account' => :info
    end
  end
end