# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::BalanceResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#info' do
    it 'returns the balance information about the current user' do
      fixture = api_fixture('balance/info')
      parsed  = JSON.parse(fixture)

      stub_do_api('/v2/customers/my/balance').to_return(body: fixture)
      balance_info = resource.info

      expect(balance_info).to be_kind_of(DropletKit::Balance)

      expect(balance_info.month_to_date_balance).to eq(parsed['month_to_date_balance'])
      expect(balance_info.account_balance).to eq(parsed['account_balance'])
      expect(balance_info.month_to_date_usage).to eq(parsed['month_to_date_usage'])
      expect(balance_info.generated_at).to eq(parsed['generated_at'])
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/customers/my/balance' }
      let(:method) { :get }
      let(:action) { :info }
    end
  end
end
