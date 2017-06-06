require 'spec_helper'

RSpec.describe DropletKit::FirewallResource do
  include_context 'resources'

  let(:firewall_fixture_path) { 'firewalls/find' }
  let(:base_path) { '/v2/firewalls' }
  let(:firewall_id) { '11d87802-df17-4f8f-a691-58e408570c12' }
  let(:firewall) do
    DropletKit::Firewall.new(
      name: 'firewall',
      inbound_rules: [
        DropletKit::FirewallInboundRule.new(
          protocol: 'icmp',
          ports: '0',
          sources: {
            tags: ['backend'],
            load_balancer_uids: ['d2d3920a-9d45-41b0-b018-d15e18ec60a4']
          }
        ),
        DropletKit::FirewallInboundRule.new(
          protocol: 'tcp',
          ports: '8000-9000',
          sources: {
            addresses: ['0.0.0.0/0']
          }
        )
      ],
      outbound_rules: [
        DropletKit::FirewallOutboundRule.new(
          protocol: 'icmp',
          ports: '0',
          destinations: {
            tags: ['backend']
          }
        ),
        DropletKit::FirewallOutboundRule.new(
          protocol: 'tcp',
          ports: '8000-9000',
          destinations: {
            addresses: ['127.0.0.0']
          }
        )
      ],
      droplet_ids: [123],
      tags: ['backend'])
  end

  subject(:resource) { described_class.new(connection: connection) }

  RSpec::Matchers.define :match_firewall_fixture do
    match do |firewall|
      expect(firewall.id).to eq('11d87802-df17-4f8f-a691-58e408570c12')
      expect(firewall.name).to eq('firewall')
      expect(firewall.status).to eq('succeeded')
      expect(firewall.created_at).to eq('2017-05-30T16:25:21Z')
      expect(firewall.inbound_rules.count).to eq(2)
      expect(firewall.inbound_rules.first.attributes)
        .to match(a_hash_including(protocol: 'icmp', ports: '0',
                                   sources: { 'load_balancer_uids' => ['d2d3920a-9d45-41b0-b018-d15e18ec60a4'],
                                              'tags' => ['backend'] }))
      expect(firewall.inbound_rules.last.attributes)
        .to match(a_hash_including(protocol: 'tcp', ports: '8000-9000',
                                   sources: { 'addresses' => ['0.0.0.0/0'] }))
      expect(firewall.outbound_rules.count).to eq(2)
      expect(firewall.outbound_rules.first.attributes)
        .to match(a_hash_including(protocol: 'icmp', ports: '0',
                                   destinations: { 'tags' => ['backend'] }))
      expect(firewall.outbound_rules.last.attributes)
        .to match(a_hash_including(protocol: 'tcp', ports: '8000-9000',
                                   destinations: { 'addresses' => ['127.0.0.0'],
                                                   'droplet_ids' => [345] }))
      expect(firewall.droplet_ids).to match_array([123])
      expect(firewall.tags).to match_array(['backend'])
      expect(firewall.pending_changes).to be_empty
    end
  end

  describe '#find' do
    it 'returns firewall' do
      stub_do_api(File.join(base_path, firewall_id), :get).to_return(body: api_fixture(firewall_fixture_path))
      firewall = resource.find(id: firewall_id)

      expect(firewall).to match_firewall_fixture
    end
  end

  describe '#create' do
    let(:path) { base_path }

    it 'returns created firewall' do
      json_body = DropletKit::FirewallMapping.representation_for(:create, firewall)
      stub_do_api(path, :post).with(body: json_body).to_return(body: api_fixture(firewall_fixture_path), status: 202)

      expect(resource.create(firewall)).to match_firewall_fixture
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::Firewall.new }
    end
  end

  describe '#update' do
    let(:path) { base_path }

    it 'returns updated firewall' do
      json_body = DropletKit::FirewallMapping.representation_for(:update, firewall)
      stub_do_api(File.join(base_path, firewall_id), :put).with(body: json_body).to_return(body: api_fixture(firewall_fixture_path), status: 200)

      expect(resource.update(firewall, id: firewall_id)).to match_firewall_fixture
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:verb) { :put }
      let(:exception) { DropletKit::FailedUpdate }
      let(:action) { 'update' }
      let(:arguments) { DropletKit::Firewall.new }
    end
  end

  describe '#all' do
    let(:firewalls_fixture_path) { 'firewalls/all' }

    it 'returns all firewalls' do
      stub_do_api(base_path, :get).to_return(body: api_fixture(firewalls_fixture_path))
      firewalls = resource.all

      expect(firewalls).to all(be_kind_of(DropletKit::Firewall))
      expect(firewalls.first).to match_firewall_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { firewalls_fixture_path }
      let(:api_path) { base_path }
    end
  end

  describe '#all_by_droplet' do
    let(:droplet_id) { 123 }
    let(:all_by_droplet_path) { "/v2/droplets/#{droplet_id}/firewalls" }
    let(:firewalls_fixture_path) { 'firewalls/all' }

    it 'returns all firewalls for a provided droplet' do
      stub_do_api(all_by_droplet_path, :get).to_return(body: api_fixture(firewalls_fixture_path))
      firewalls = resource.all_by_droplet(droplet_id: droplet_id)

      expect(firewalls).to all(be_kind_of(DropletKit::Firewall))
      expect(firewalls.first).to match_firewall_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { firewalls_fixture_path }
      let(:action) { :all_by_droplet }
      let(:parameters) { { droplet_id: droplet_id } }
      let(:api_path) { all_by_droplet_path }
    end
  end

  describe '#delete' do
    it 'sends request to delete given firewall' do
      request = stub_do_api(File.join(base_path, firewall_id), :delete)
      resource.delete(id: firewall_id)

      expect(request).to have_been_made
    end
  end

  context 'droplets' do
    let(:droplet_id_1) { 1 }
    let(:droplet_id_2) { 2 }

    describe '#add_droplets' do
      it 'sends request to add droplets for a given firewall' do
        request = stub_do_api(File.join(base_path, firewall_id, 'droplets'), :post).with(body: { droplet_ids: [droplet_id_1, droplet_id_2] }.to_json)
        resource.add_droplets([droplet_id_1, droplet_id_2], id: firewall_id)

        expect(request).to have_been_made
      end
    end

    describe '#remove_droplets' do
      it 'sends request to remove droplets from a given firewall' do
        request = stub_do_api(File.join(base_path, firewall_id, 'droplets'), :delete).with(body: { droplet_ids: [droplet_id_1, droplet_id_2]}.to_json)
        resource.remove_droplets([droplet_id_1, droplet_id_2], id: firewall_id)

        expect(request).to have_been_made
      end
    end
  end

  context 'tags' do
    let(:frontend_tag) { 'frontend' }
    let(:backend_tag) { 'backend' }

    describe '#add_tags' do
      it 'sends request to add tags for a given firewall' do
        request = stub_do_api(File.join(base_path, firewall_id, 'tags'), :post).with(body: { tags: [frontend_tag, backend_tag] }.to_json)
        resource.add_tags([frontend_tag, backend_tag], id: firewall_id)

        expect(request).to have_been_made
      end
    end

    describe '#remove_tags' do
      it 'sends request to remove tags from a given firewall' do
        request = stub_do_api(File.join(base_path, firewall_id, 'tags'), :delete).with(body: { tags: [frontend_tag, backend_tag]}.to_json)
        resource.remove_tags([frontend_tag, backend_tag], id: firewall_id)

        expect(request).to have_been_made
      end
    end
  end

  context 'rules' do
    let(:inbound_rule) do
      DropletKit::FirewallInboundRule.new(
        protocol: 'tcp',
        ports: '22',
        sources: {
          addresses: ['127.0.0.0'],
          tags: ['frontend', 'backend']
        }
      )
    end

    let(:outbound_rule) do
      DropletKit::FirewallOutboundRule.new(
        protocol: 'tcp',
        ports: '8080',
        destinations: {
          droplet_ids: [123, 456],
          load_balancer_uids: ['lb-uuid']
        }
      )
    end

    let(:rules) do
      DropletKit::FirewallRule.new(
        inbound_rules: [inbound_rule],
        outbound_rules: [outbound_rule]
      )
    end

    describe '#add_rules' do
      it 'sends request to add rules for a given firewall' do
        json_body = DropletKit::FirewallRuleMapping.representation_for(:create, rules)
        request = stub_do_api(File.join(base_path, firewall_id, 'rules'), :post).with(body: json_body)
        resource.add_rules(inbound_rules: [inbound_rule], outbound_rules: [outbound_rule], id: firewall_id)

        expect(request).to have_been_made
      end
    end

    describe '#remove_rules' do
      it 'sends request to remove rules from a given firewall' do
        json_body = DropletKit::FirewallRuleMapping.representation_for(:update, rules)
        request = stub_do_api(File.join(base_path, firewall_id, 'rules'), :delete).with(body: json_body)
        resource.remove_rules(inbound_rules: [inbound_rule], outbound_rules: [outbound_rule], id: firewall_id)

        expect(request).to have_been_made
      end
    end
  end
end
