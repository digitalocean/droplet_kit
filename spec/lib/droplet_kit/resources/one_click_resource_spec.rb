# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::OneClickResource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  describe '#all' do
    it 'returns kubernetes 1-click apps' do
      stub_do_api('/v2/1-clicks?type=kubernetes', :get).to_return(body: api_fixture('one_clicks/all'))
      one_clicks = resource.all(type: 'kubernetes')
      expect(one_clicks).to all(be_a(DropletKit::OneClick))

      expect(one_clicks.first.slug).to eq('monitoring')
      expect(one_clicks.first.type).to eq('kubernetes')
    end

    it 'returns droplet 1-click apps' do
      stub_do_api('/v2/1-clicks?type=droplet', :get).to_return(body: api_fixture('one_clicks/all'))
      one_clicks = resource.all(type: 'droplet')
      expect(one_clicks).to all(be_a(DropletKit::OneClick))

      expect(one_clicks.last.slug).to eq('wordpress-18-04')
      expect(one_clicks.last.type).to eq('droplet')
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/1-clicks' }
      let(:method) { :get }
      let(:action) { :all }
      let(:arguments) { { type: 'kubernetes' } }
    end
  end

  describe '#create_kubernetes' do
    context 'with a successful create' do
      it 'returns a message' do
        one_click_kubernetes = DropletKit::OneClickKubernetes.new(
          addon_slugs: %w[slug1 slug2],
          cluster_uuid: '177dc8c-12c1-4483-af1c-877eed0f14cb'
        )

        json = DropletKit::OneClickKubernetesMapping.representation_for(:create, one_click_kubernetes)
        stub_do_api('/v2/1-clicks/kubernetes', :post).with(body: json).to_return(body: api_fixture('one_clicks/create_kubernetes'), status: 200)
        response = resource.create_kubernetes(one_click_kubernetes)
        expect(response).to eq('{ "message": "Successfully kicked off addon job." }')
      end
    end
  end
end
