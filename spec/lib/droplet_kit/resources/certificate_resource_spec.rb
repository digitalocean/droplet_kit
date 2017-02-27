require 'spec_helper'

RSpec.describe DropletKit::CertificateResource do
  include_context 'resources'

  let(:certificate_fixture_path) { 'certificates/find' }
  let(:base_path) { '/v2/certificates'}
  let(:certificate_id) { '892071a0-bb95-49bc-8021-3afd67a210bf' }
  subject(:resource) { described_class.new(connection: connection) }

  RSpec::Matchers.define :match_certificate_fixture do
    match do |certificate|
      expect(certificate.id).to eq('892071a0-bb95-49bc-8021-3afd67a210bf')
      expect(certificate.name).to eq('web-cert-01')
      expect(certificate.not_after).to eq('2017-02-22T00:23:00Z')
      expect(certificate.sha1_fingerprint).to eq('dfcc9f57d86bf58e321c2c6c31c7a971be244ac7')
      expect(certificate.created_at).to eq('2017-02-08T16:02:37Z')
    end
  end

  describe '#find' do
    let(:certificate) do
      DropletKit::Certificate.new(
        id: '892071a0-bb95-49bc-8021-3afd67a210bf',
        name: 'web-cert-01',
        not_after: '2017-02-22T00:23:00Z',
        sha1_fingerprint: 'dfcc9f57d86bf58e321c2c6c31c7a971be244ac7',
        created_at: '2017-02-08T16:02:37Z'
      )
    end

    it 'returns certificate' do
      stub_do_api(File.join(base_path, certificate_id), :get).to_return(body: api_fixture(certificate_fixture_path))
      certificate = resource.find(id: certificate_id)

      expect(certificate).to match_certificate_fixture
    end
  end

  describe '#all' do
    let(:certificates_fixture_path) { 'certificates/all' }

    it 'returns all of the certificates' do
      stub_do_api(base_path, :get).to_return(body: api_fixture(certificates_fixture_path))
      certificates = resource.all

      expect(certificates).to all(be_kind_of(DropletKit::Certificate))
      expect(certificates.first).to match_certificate_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { certificates_fixture_path }
      let(:api_path) { base_path }
    end
  end

  describe '#create' do
    let(:path) { base_path }

    let(:certificate) do
      DropletKit::Certificate.new(
        name: 'web-cert-01',
        private_key: '-----BEGIN PRIVATE KEY-----',
        leaf_certificate: '-----BEGIN CERTIFICATE-----',
        certificate_chain: '-----BEGIN CERTIFICATE-----'
      )
    end

    it 'returns created certificate' do
      json_body = DropletKit::CertificateMapping.representation_for(:create, certificate)
      stub_do_api(path, :post).with(body: json_body).to_return(body: api_fixture(certificate_fixture_path), status: 201)

      expect(resource.create(certificate)).to match_certificate_fixture
    end

    it_behaves_like 'an action that handles invalid parameters' do
      let(:action) { 'create' }
      let(:arguments) { DropletKit::Certificate.new }
    end
  end

  describe '#delete' do
    it 'sends a delete request for the certificate' do
      request = stub_do_api(File.join(base_path, certificate_id), :delete)
      resource.delete(id: certificate_id)

      expect(request).to have_been_made
    end
  end
end
