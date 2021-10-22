# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::VPCResource do
  include_context 'resources'

  let(:vpc_fixture_path) { 'vpcs/find' }
  let(:default_vpc_fixture_path) { 'vpcs/find_default' }
  let(:base_path) { '/v2/vpcs'}
  let(:vpc_uuid) { '880b7f98-f062-404d-b33c-458d545696f6' }

  subject(:resource) { described_class.new(connection: connection) }

  RSpec::Matchers.define :match_vpc_fixture do
    match do |vpc|
      expect(vpc.id).to eq('880b7f98-f062-404d-b33c-458d545696f6')
      expect(vpc.urn).to eq('do:vpc:880b7f98-f062-404d-b33c-458d545696f6')
      expect(vpc.name).to eq('my-new-vpc-1')
      expect(vpc.description).to eq('vpc desc')
      expect(vpc.ip_range).to eq('10.108.0.0/20')
      expect(vpc.region).to eq('nyc3')
      expect(vpc.default).to be_falsy
      expect(vpc.created_at).to eq('2019-03-29T21:48:40.995304079Z')
    end
  end

  RSpec::Matchers.define :match_default_vpc_fixture do
    match do |vpc|
      expect(vpc.id).to eq('880b7f98-f062-404d-b33c-458d545696f6')
      expect(vpc.urn).to eq('do:vpc:880b7f98-f062-404d-b33c-458d545696f6')
      expect(vpc.name).to eq('my-new-vpc-1')
      expect(vpc.description).to eq('vpc desc')
      expect(vpc.ip_range).to eq('10.108.0.0/20')
      expect(vpc.region).to eq('nyc3')
      expect(vpc.default).to be_truthy
      expect(vpc.created_at).to eq('2019-03-29T21:48:40.995304079Z')
    end
  end

  RSpec::Matchers.define :match_vpc_member_fixture do
    match do |member|
      expect(member.urn).to eq('do:loadbalancer:f79f2306-e26a-4625-a71b-7816d17e3a6c')
      expect(member.name).to eq('load-balancer')
      expect(member.created_at).to eq('2019-03-29T20:41:52Z')
    end
  end

  describe '#find' do
    it 'returns vpc' do
      stub_do_api(File.join(base_path, vpc_uuid), :get).to_return(body: api_fixture(vpc_fixture_path))
      vpc = resource.find(id: vpc_uuid)

      expect(vpc).to match_vpc_fixture
    end
  end

  describe '#all' do
    let(:vpcs_fixture_path) { 'vpcs/all' }

    it 'returns all of the vpcs' do
      stub_do_api(base_path, :get).to_return(body: api_fixture(vpcs_fixture_path))
      vpcs = resource.all

      expect(vpcs).to all(be_kind_of(DropletKit::VPC))
      expect(vpcs.first).to match_vpc_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { vpcs_fixture_path }
      let(:api_path) { base_path }
    end
  end

  context 'create, update and patch' do
    let(:vpc) do
      DropletKit::VPC.new(
        name: 'example-vpc',
      )
    end

    describe '#create' do
      let(:path) { base_path }

      it 'returns created vpc' do
        json_body = DropletKit::VPCMapping.representation_for(:create, vpc)
        stub_do_api(path, :post).with(body: json_body).to_return(body: api_fixture(vpc_fixture_path), status: 201)

        expect(resource.create(vpc)).to match_vpc_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:action) { 'create' }
        let(:arguments) { DropletKit::VPC.new }
      end
    end

    describe '#update' do
      let(:path) { base_path }

      it 'returns updated vpc' do
        json_body = DropletKit::VPCMapping.representation_for(:update, vpc)
        stub_do_api(File.join(base_path, vpc_uuid), :put).with(body: json_body).to_return(body: api_fixture(vpc_fixture_path), status: 200)

        expect(resource.update(vpc, id: vpc_uuid)).to match_vpc_fixture
      end

      it 'allows a VPC to be set as default' do
        vpc.default = true

        json_body = DropletKit::VPCMapping.representation_for(:update, vpc)
        stub_do_api(File.join(base_path, vpc_uuid), :put).with(body: json_body).to_return(body: api_fixture(default_vpc_fixture_path), status: 200)

        expect(resource.update(vpc, id: vpc_uuid)).to match_default_vpc_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:verb) { :put }
        let(:exception) { DropletKit::FailedUpdate }
        let(:action) { 'update' }
        let(:arguments) { DropletKit::VPC.new }
      end
    end

    describe '#patch' do
      let(:path) { base_path }

      it 'returns patched vpc' do
        json_body = DropletKit::VPCMapping.representation_for(:patch, vpc)
        stub_do_api(File.join(base_path, vpc_uuid), :patch).with(body: json_body).to_return(body: api_fixture(vpc_fixture_path), status: 200)

        expect(resource.patch(vpc, id: vpc_uuid)).to match_vpc_fixture
      end

      it 'allows a VPC to be set as default' do
        vpc = DropletKit::VPC.new(default: true)
        json_body = DropletKit::VPCMapping.representation_for(:patch, vpc)

        stub_do_api(File.join(base_path, vpc_uuid), :patch).with(body: json_body).to_return(body: api_fixture(default_vpc_fixture_path), status: 200)

        expect(resource.patch(vpc, id: vpc_uuid)).to match_default_vpc_fixture
      end

      it_behaves_like 'an action that handles invalid parameters' do
        let(:verb) { :patch }
        let(:exception) { DropletKit::FailedUpdate }
        let(:action) { 'patch' }
        let(:arguments) { DropletKit::VPC.new }
      end
    end
  end

  describe '#delete' do
    it 'sends a delete request for the vpc' do
      request = stub_do_api(File.join(base_path, vpc_uuid), :delete)
      resource.delete(id: vpc_uuid)

      expect(request).to have_been_made
    end
  end

  describe '#all_members' do
    let(:vpc_members_fixture_path) { 'vpcs/all_members' }

    it 'returns all of the vpc members' do
      stub_do_api(base_path, :get).to_return(body: api_fixture(vpc_members_fixture_path))
      vpc_members = resource.all_members

      expect(vpc_members).to all(be_kind_of(DropletKit::VPCMember))
      expect(vpc_members.first).to match_vpc_member_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { vpc_members_fixture_path }
      let(:api_path) { base_path }
    end
  end
end
