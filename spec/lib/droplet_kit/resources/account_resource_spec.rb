require 'spec_helper'

RSpec.describe DropletKit::AccountResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#info' do
    it 'returns the information about the current user' do
      fixture = api_fixture('account/info')
      parsed  = JSON.load(fixture)

      stub_do_api('/v2/account').to_return(body: fixture)
      account_info = resource.info

      expect(account_info).to be_kind_of(DropletKit::Account)

      expect(account_info.droplet_limit).to eq(parsed['account']['droplet_limit'])
      expect(account_info.floating_ip_limit).to eq(parsed['account']['floating_ip_limit'])
      expect(account_info.email).to eq(parsed['account']['email'])
      expect(account_info.uuid).to eq(parsed['account']['uuid'])
      expect(account_info.email_verified).to eq(parsed['account']['email_verified'])
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/account' }
      let(:method) { :get }
      let(:action) { :info }
    end
  end
end
