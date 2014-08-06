module DropletKit
  class SSHKeyResource < ResourceKit::Resource
    resources do
      default_handler(200, 201) {|r| SSHKeyMapping.extract_single(r.body, :read) }

      action :all, 'GET /v2/account/keys' do
        handler(:ok) { |response| SSHKeyMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/account/keys' do
        body {|object| SSHKeyMapping.representation_for(:create, object) }
      end

      action :find, 'GET /v2/account/keys/:id'
    end
  end
end