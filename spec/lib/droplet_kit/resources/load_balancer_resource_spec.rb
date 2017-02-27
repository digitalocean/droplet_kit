require 'spec_helper'

RSpec.describe DropletKit::LoadBalancerResource do
  include_context 'resources'

  let(:load_balancer_fixture_path) { 'load_balancers/find' }
  let(:base_path) { '/v2/load_balancers'}
  let(:load_balancer_id) { '37e6be88-01ec-4ec7-9bc6-a514d4719057' }

  subject(:resource) { described_class.new(connection: connection) }

  RSpec::Matchers.define :match_load_balancer_fixture do
    match do |load_balancer|
      expect(load_balancer.name).to eq('example-lb-01')
      expect(load_balancer.id).to eq('4de7ac8b-495b-4884-9a69-1050c6793cd6')
      expect(load_balancer.ip).to eq('104.131.186.241')
      expect(load_balancer.algorithm).to eq('round_robin')
      expect(load_balancer.status).to eq('active')
      expect(load_balancer.created_at).to eq('2017-02-01T22:22:58Z')
      expect(load_balancer.tag).to be_blank
      expect(load_balancer.region).to be_kind_of(DropletKit::Region)
      expect(load_balancer.region.attributes)
        .to match(a_hash_including(slug: 'nyc3', name: 'New York 3',
                                   available: true, sizes: ['512mb'], features: ['private_networking']))
      expect(load_balancer.droplet_ids).to match_array([3164445, 3164444])
      expect(load_balancer.sticky_sessions).to be_kind_of(DropletKit::StickySession)
      expect(load_balancer.sticky_sessions.attributes)
        .to match(a_hash_including(cookie_ttl_seconds: 5, cookie_name: 'DO-LB', type: 'cookies'))
      expect(load_balancer.health_check).to be_kind_of(DropletKit::HealthCheck)
      expect(load_balancer.health_check.attributes)
        .to match(a_hash_including(protocol: 'http', port: 80, path: '/',
                                   check_interval_seconds: 10, response_timeout_seconds: 5,
                                   healthy_threshold: 5, unhealthy_threshold: 3))
      expect(load_balancer.forwarding_rules.count).to eq(2)
      expect(load_balancer.forwarding_rules.first.attributes)
        .to match(a_hash_including(entry_protocol: 'http', entry_port: 80,
                                   target_protocol: 'http', target_port: 80,
                                   certificate_id: '', tls_passthrough: false))
      expect(load_balancer.forwarding_rules.last.attributes)
        .to match(a_hash_including(entry_protocol: 'https', entry_port: 444,
                                   target_protocol: 'https', target_port: 443,
                                   certificate_id: 'my-cert', tls_passthrough: true))
    end
  end

  describe '#find' do
    it 'returns load balancer' do
      stub_do_api(File.join(base_path, load_balancer_id), :get).to_return(body: api_fixture(load_balancer_fixture_path))
      load_balancer = resource.find(id: load_balancer_id)

      expect(load_balancer).to match_load_balancer_fixture
    end
  end

  describe '#all' do
    let(:load_balancers_fixture_path) { 'load_balancers/all' }

    it 'returns all of the load balancers' do
      stub_do_api(base_path, :get).to_return(body: api_fixture(load_balancers_fixture_path))
      load_balancers = resource.all

      expect(load_balancers).to all(be_kind_of(DropletKit::LoadBalancer))
      expect(load_balancers.first).to match_load_balancer_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { load_balancers_fixture_path }
      let(:api_path) { base_path }
    end
  end

  context 'create and update' do
    let(:load_balancer) do
      DropletKit::LoadBalancer.new(
        name: 'example-lb-01',
        algorithm: 'round_robin',
        droplet_ids: [ 3164444, 3164445],
        redirect_http_to_https: true,
        region: 'nyc1',
        forwarding_rules: [
          DropletKit::ForwardingRule.new(
            entry_protocol: 'https',
            entry_port: 444,
            target_protocol: 'https',
            target_port: 443,
            certificate_id: 'my-cert',
            tls_passthrough: false
          )
        ],
        sticky_sessions: DropletKit::StickySession.new(
          type: 'cookies',
          cookie_name: 'DO-LB',
          cookie_ttl_seconds: 5
        ),
        health_check: DropletKit::HealthCheck.new(
          protocol: 'http',
          port: 80,
          path: 'index.html',
          check_interval_seconds: 10,
          response_timeout_seconds: 5,
          healthy_threshold: 5,
          unhealthy_threshold: 3
        )
      )
    end

    describe '#create' do
      let(:path) { base_path }

      it 'returns created load balancer' do
        json_body = DropletKit::LoadBalancerMapping.representation_for(:create, load_balancer)
        stub_do_api(path, :post).with(body: json_body).to_return(body: api_fixture(load_balancer_fixture_path), status: 202)

        expect(resource.create(load_balancer)).to match_load_balancer_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:action) { 'create' }
        let(:arguments) { DropletKit::LoadBalancer.new }
      end
    end

    describe '#update' do
      let(:path) { base_path }

      it 'returns updated load balancer' do
        json_body = DropletKit::LoadBalancerMapping.representation_for(:update, load_balancer)
        stub_do_api(File.join(base_path, load_balancer_id), :put).with(body: json_body).to_return(body: api_fixture(load_balancer_fixture_path), status: 200)

        expect(resource.update(load_balancer, id: load_balancer_id)).to match_load_balancer_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:action) { 'create' }
        let(:arguments) { DropletKit::LoadBalancer.new }
      end
    end
  end

  describe '#delete' do
    it 'sends a delete request for the load balancer' do
      request = stub_do_api(File.join(base_path, load_balancer_id), :delete)
      resource.delete(id: load_balancer_id)

      expect(request).to have_been_made
    end
  end

  context 'droplets' do
    let(:droplet_id_1) { 1 }
    let(:droplet_id_2) { 2 }

    describe '#add_droplets' do
      it 'sends a post request for the load balancer to add droplets' do
        request = stub_do_api(File.join(base_path, load_balancer_id, 'droplets'), :post).with(body: { droplet_ids: [droplet_id_1, droplet_id_2] }.to_json)
        resource.add_droplets([droplet_id_1, droplet_id_2], id: load_balancer_id)

        expect(request).to have_been_made
      end
    end

    describe '#remove_droplets' do
      it 'sends a delete request for the load balancer to remove droplet' do
        request = stub_do_api(File.join(base_path, load_balancer_id, 'droplets'), :delete).with(body: { droplet_ids: [droplet_id_1]}.to_json)
        resource.remove_droplets([droplet_id_1], id: load_balancer_id)

        expect(request).to have_been_made
      end
    end
  end

  context 'forwarding_rules' do
    let(:forwarding_rule_1) do
      DropletKit::ForwardingRule.new(
        entry_protocol: 'tcp',
        entry_port: 3306,
        target_protocol: 'tcp',
        target_port: 3306
      )
    end

    let(:forwarding_rule_2) do
      DropletKit::ForwardingRule.new(
        entry_protocol: 'https',
        entry_port: 444,
        target_protocol: 'https',
        target_port: 443,
        certificate_id: '',
        tls_passthrough: true
      )
    end

    describe '#add_forwarding_rules' do
      it 'sends a post request for the load balancer to add forwarding rules' do
        json_body = DropletKit::ForwardingRuleMapping.represent_collection_for(:create, [forwarding_rule_1, forwarding_rule_2])
        request = stub_do_api(File.join(base_path, load_balancer_id, 'forwarding_rules'), :post).with(body: json_body)
        resource.add_forwarding_rules([forwarding_rule_1, forwarding_rule_2], id: load_balancer_id)

        expect(request).to have_been_made
      end
    end

    describe '#remove_forwarding_rules' do
      it 'sends a delete request for the load balancer to remove forwarding rule' do
        json_body = DropletKit::ForwardingRuleMapping.represent_collection_for(:update, [forwarding_rule_1])
        request = stub_do_api(File.join(base_path, load_balancer_id, 'forwarding_rules'), :delete).with(body: json_body)
        resource.remove_forwarding_rules([forwarding_rule_1], id: load_balancer_id)

        expect(request).to have_been_made
      end
    end
  end
end
