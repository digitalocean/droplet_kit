# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::VPCPeeringResource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  let(:vpc_peering_fixture_path) { 'vpc_peerings/find' }
  let(:base_path) { '/v2/vpc_peerings' }
  let(:vpc_peering_uuid) { '880b7f98-f062-404d-b33c-458d545696f6' }

  RSpec::Matchers.define :match_vpc_peering_fixture do
    match do |vpc_peering|
      expect(vpc_peering.id).to eq('6e9bff8e-2d65-4301-9a48-f80a25ad89fa')
      expect(vpc_peering.name).to eq('my-new-vpc-peering-1')
      expect(vpc_peering.vpc_ids).to eq(%w[880b7f98-f062-404d-b33c-458d545696f6 be76c5b4-c6c4-4fbb-a710-edbfe76c1982])
      expect(vpc_peering.created_at).to eq('2024-04-03T21:48:41.995304079Z')
      expect(vpc_peering.status).to eq('ACTIVE')
    end
  end

  describe '#find' do
    it 'returns vpc peering' do
      stub_do_api(File.join(base_path, vpc_peering_uuid), :get).to_return(body: api_fixture(vpc_peering_fixture_path))
      vpc_peering = resource.find(id: vpc_peering_uuid)

      expect(vpc_peering).to match_vpc_peering_fixture
    end
  end

  describe '#all' do
    let(:vpcs_fixture_path) { 'vpc_peerings/all' }

    it 'returns all of the vpc peerings' do
      stub_do_api(base_path, :get).to_return(body: api_fixture(vpcs_fixture_path))
      vpcs = resource.all

      expect(vpcs).to all(be_a(DropletKit::VPCPeering))
      expect(vpcs.first).to match_vpc_peering_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { vpcs_fixture_path }
      let(:api_path) { base_path }
    end
  end

  context 'when creating, updating and patching' do
    let(:vpc_peering) do
      DropletKit::VPCPeering.new(
        name: 'example-vpc-peering'
      )
    end

    describe '#create' do
      let(:path) { base_path }

      it 'returns created vpc peering' do
        json_body = DropletKit::VPCPeeringMapping.representation_for(:create, vpc_peering)
        stub_do_api(path, :post).with(body: json_body).to_return(body: api_fixture(vpc_peering_fixture_path), status: 202)

        expect(resource.create(vpc_peering)).to match_vpc_peering_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:action) { 'create' }
        let(:arguments) { DropletKit::VPCPeering.new }
      end
    end

    describe '#update' do
      let(:path) { base_path }

      it 'returns updated vpc peering' do
        json_body = DropletKit::VPCPeeringMapping.representation_for(:update, vpc_peering)
        stub_do_api(File.join(base_path, vpc_peering_uuid), :put).with(body: json_body).to_return(body: api_fixture(vpc_peering_fixture_path), status: 200)

        expect(resource.update(vpc_peering, id: vpc_peering_uuid)).to match_vpc_peering_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:verb) { :put }
        let(:exception) { DropletKit::FailedUpdate }
        let(:action) { 'update' }
        let(:arguments) { DropletKit::VPCPeering.new }
      end
    end

    describe '#patch' do
      let(:path) { base_path }

      it 'returns patched vpc peering' do
        json_body = DropletKit::VPCPeeringMapping.representation_for(:patch, vpc_peering)
        stub_do_api(File.join(base_path, vpc_peering_uuid), :patch).with(body: json_body).to_return(body: api_fixture(vpc_peering_fixture_path), status: 200)

        expect(resource.patch(vpc_peering, id: vpc_peering_uuid)).to match_vpc_peering_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:verb) { :patch }
        let(:exception) { DropletKit::FailedUpdate }
        let(:action) { 'patch' }
        let(:arguments) { DropletKit::VPCPeering.new }
      end
    end
  end

  describe '#delete' do
    it 'sends a delete request for the vpc' do
      request = stub_do_api(File.join(base_path, vpc_peering_uuid), :delete)
      resource.delete(id: vpc_peering_uuid)

      expect(request).to have_been_made
    end
  end
end
