require 'spec_helper'

RSpec.describe DropletKit::CDNResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  let(:id) { '7724db7c-e098-11e5-b522-000f53304e51' }
  let(:origin) { 'my-space-cdn.nyc3.digitaloceanspaces.com' }
  let(:endpoint) { 'my-space-cdn.nyc3.cdn.digitaloceanspaces.com' }
  let(:ttl) { 3600 }
  let(:created_at) { '2016-03-02T17:00:49Z' }

  let(:path) { '/v2/cdn/endpoints' }
  let(:path_with_id) { "#{path}/#{id}" }

  RSpec::Matchers.define :match_cdn_fixture do
    match do |cdn|
      expect(cdn).to be_kind_of(DropletKit::CDN)

      expect(cdn.id).to eq(id)
      expect(cdn.origin).to eq(origin)
      expect(cdn.endpoint).to eq(endpoint)
      expect(cdn.ttl).to eq(ttl)
      expect(cdn.created_at).to eq(created_at)
    end
  end

  describe '#all' do
    it 'returns all of the cdns' do
      stub_do_api(path, :get).to_return(body: api_fixture('cdns/all'))
      cdns = resource.all

      expect(cdns).to all(be_kind_of(DropletKit::CDN))
      expect(cdns.first).to match_cdn_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'cdns/all' }
      let(:api_path) { '/v2/cdn/endpoints' }
    end
  end

  describe '#find' do
    it 'returns a singular cdn' do
      stub_do_api(path_with_id, :get).to_return(body: api_fixture('cdns/find'))
      cdn = resource.find(id: id)

      expect(cdn).to match_cdn_fixture
    end
  end

  describe '#create' do
    it 'returns the created cdn' do
      cdn = DropletKit::CDN.new(
        origin: origin,
        ttl: ttl
      )

      as_string = DropletKit::CDNMapping.representation_for(:create, cdn)
      stub_do_api(path, :post).with(body: as_string).to_return(body: api_fixture('cdns/create'), status: 201)
      created_cdn = resource.create(cdn)

      expect(created_cdn).to match_cdn_fixture
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::CDN.new }
    end
  end

  describe '#update_ttl' do
    let(:exception) { DropletKit::FailedUpdate }

    it 'returns the updated cdn' do
      as_string = { ttl: 60 }.to_json
      stub_do_api(path_with_id, :put).with(body: as_string).to_return(body: api_fixture('cdns/update_ttl'))
      updated_cdn = resource.update_ttl(id: id, ttl: 60)

      expect(updated_cdn).to be_kind_of(DropletKit::CDN)

      expect(updated_cdn.id).to eq(id)
      expect(updated_cdn.ttl).to eq(60)
    end

    it "fails if ttl is invalid" do
      as_string = { ttl: 0 }.to_json
      response_body = { id: :unprocessable_entity, message: 'invalid ttl' }
      stub_do_api(path_with_id, :put).with(body: as_string).to_return(body: response_body.to_json, status: 422)

      expect { resource.update_ttl(id: id, ttl: 0) }.to raise_exception(exception).with_message(response_body[:message])
    end
  end

  describe '#flush_cache' do
    let(:cache_path) { "/v2/cdn/endpoints/#{id}/cache" }
    let(:exception) { DropletKit::FailedUpdate }

    it 'sends a delete request to cdn cache' do
      as_string = { files: ["*"] }.to_json
      request = stub_do_api(cache_path, :delete).with(body: as_string)
      resource.flush_cache(id: id, files: ["*"])

      expect(request).to have_been_made
    end

    it "fails if files are not passed in" do
      as_string = { files: [] }.to_json
      response_body = { id: :unprocessable_entity, message: 'invalid request body' }
      stub_do_api(cache_path, :delete).with(body: as_string).to_return(body: response_body.to_json, status: 422)

      expect { resource.flush_cache(id: id, files: []) }.to raise_exception(exception).with_message(response_body[:message])
    end
  end

  describe '#delete' do
    it 'sends a delete request for the cdn' do
      request = stub_do_api(path_with_id, :delete)
      resource.delete(id: id)

      expect(request).to have_been_made
    end
  end
end
