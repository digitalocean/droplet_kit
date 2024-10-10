# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DropletKit::AppResource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  let(:app_uuid) { 'c2a93513-8d9b-4223-9d61-5e7272c81cf5' }

  RSpec::Matchers.define :match_app_fixture do
    match do |app|
      expect(app.id).to eq('c2a93513-8d9b-4223-9d61-5e7272c81cf5')
      expect(app.owner_uuid).to eq('a4e16f25-cdd1-4483-b246-d77f283c9209')
      expect(app.spec.name).to eq('sample-golang')
      expect(app.spec.services.first.name).to eq('web')
      expect(app.spec.services.first.github.repo).to eq('ChiefMateStarbuck/sample-golang')
      expect(app.spec.services.first.github.branch).to eq('main')
      expect(app.spec.services.first.run_command).to eq('bin/sample-golang')
      expect(app.spec.services.first.environment_slug).to eq('go')
      expect(app.spec.services.first.instance_size_slug).to eq('apps-s-1vcpu-0.5gb')
      expect(app.spec.services.first.instance_count).to eq(1)
      expect(app.spec.services.first.http_port).to eq(8080)
      expect(app.spec.region).to eq('ams')
      expect(app.spec.domains.first.domain).to eq('sample-golang.example.com')
      expect(app.spec.domains.first.zone).to eq('example.com')
      expect(app.spec.domains.first.minimum_tls_version).to eq('1.3')
      expect(app.default_ingress).to eq('https://sample-golang-zyhgn.ondigitalocean.app')
      expect(app.created_at).to eq('2021-02-10T16:45:14Z')
      expect(app.updated_at).to eq('2021-02-10T17:06:56Z')
      expect(app.active_deployment.id).to eq('991dfa59-6a23-459f-86d6-67dfa2c6f1e3')
      expect(app.active_deployment.spec.services.first.name).to eq('web')
      expect(app.active_deployment.services.first.source_commit_hash).to eq('db6936cb46047c576962962eed81ad52c21f35d7')
      expect(app.active_deployment.phase).to eq('ACTIVE')
      expect(app.last_deployment_created_at).to eq('2021-02-10T17:05:30Z')
      expect(app.live_url).to eq('https://sample-golang-zyhgn.ondigitalocean.app')
      expect(app.pending_deployment.id).to eq('3aa4d20e-5527-4c00-b496-601fbd22520a')
      expect(app.pending_deployment.spec.services.first.name).to eq('sample-php')
      expect(app.pending_deployment.spec.services.first.git.repo_clone_url).to eq(
        'https://github.com/digitalocean/sample-php.git'
      )
      expect(app.pending_deployment.spec.services.first.git.branch).to eq('main')
      expect(app.pending_deployment.spec.services.first.run_command).to eq('heroku-php-apache2')
      expect(app.pending_deployment.spec.services.first.environment_slug).to eq('php')
      expect(app.pending_deployment.spec.services.first.instance_size_slug).to eq('apps-s-1vcpu-0.5gb')
      expect(app.pending_deployment.spec.services.first.instance_count).to eq(1)
      expect(app.pending_deployment.spec.services.first.http_port).to eq(8080)
      expect(app.pending_deployment.spec.region).to eq('fra')
      expect(app.pending_deployment.spec.domains.first.domain).to eq('sample-php.example.com')
      expect(app.pending_deployment.spec.domains.first.type).to eq('PRIMARY')
      expect(app.pending_deployment.spec.domains.first.zone).to eq('example.com')
      expect(app.pending_deployment.spec.domains.first.minimum_tls_version).to eq('1.3')
      expect(app.region.slug).to eq('ams')
      expect(app.region.label).to eq('Amsterdam')
      expect(app.region.flag).to eq('netherlands')
      expect(app.region.continent).to eq('Europe')
      expect(app.region.data_centers).to eq(['ams3'])
      expect(app.tier_slug).to eq('basic')
      expect(app.live_url_base).to eq('https://sample-golang-zyhgn.ondigitalocean.app')
      expect(app.live_domain).to eq('sample-golang-zyhgn.ondigitalocean.app')
      expect(app.project_id).to eq('88b72d1a-b78a-4d9f-9090-b53c4399073f')
      expect(app.domains.first.id).to eq('e206c64e-a1a3-11ed-9e6e-9b7b6dc9a52b')
      expect(app.domains.first.phase).to eq('CONFIGURING')
      expect(app.domains.first.spec.domain).to eq('sample-golang.example.com')
      expect(app.domains.first.spec.type).to eq('PRIMARY')
      expect(app.domains.first.spec.zone).to eq('example.com')
      expect(app.domains.first.spec.minimum_tls_version).to eq('1.3')
      expect(app.domains.first.rotate_validation_records).to be_falsey
      expect(app.domains.first.certificate_expires_at).to eq('2024-01-29T23:59:59Z')
      expect(app.dedicated_ips.map(&:ip)).to contain_exactly('192.168.1.1', '192.168.1.2')
      expect(app.dedicated_ips.map(&:status)).to all(eq('ASSIGNED'))
    end
  end

  describe '#find' do
    it 'returns app' do
      stub_do_api("/v2/apps/#{app_uuid}", :get).to_return(body: api_fixture('apps/find'))
      app = resource.find(id: app_uuid)

      expect(app).to match_app_fixture
    end
  end

  describe '#all' do
    it 'returns all of the apps' do
      stub_do_api('/v2/apps', :get).to_return(body: api_fixture('apps/all'))
      apps = resource.all

      expect(apps).to all(be_a(DropletKit::App))
      expect(apps.first).to match_app_fixture
    end

    it 'returns all of the apps with with projects' do
      stub_do_api('/v2/apps', :get).with(query: hash_including({ 'with_projects' => 'true' })).to_return(
        body: api_fixture('apps/all')
      )
      apps = resource.all(with_projects: true)

      expect(apps).to all(be_a(DropletKit::App))
      expect(apps.first).to match_app_fixture
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'apps/all' }
      let(:api_path) { '/v2/apps' }
    end
  end

  context 'when creating, updating, and deleting' do
    let(:app) do
      DropletKit::App.new(
        spec: DropletKit::AppSpec.new(
          name: 'web-app',
          region: 'nyc',
          services: [
            DropletKit::AppServiceSpec.new(
              name: 'api',
              github: DropletKit::AppGitHubSourceSpec.new(
                branch: 'main',
                deploy_on_push: true,
                repo: 'digitalocean/sample-golang'
              ),
              run_command: 'bin/api',
              environment_slug: 'node-js',
              instance_count: 2,
              instance_size_slug: 'apps-s-1vcpu-0.5gb'
            )
          ],
          egress: DropletKit::AppEgressSpec.new(
            type: 'DEDICATED_IP'
          )
        ),
        project_id: '88b72d1a-b78a-4d9f-9090-b53c4399073f',
        update_all_source_versions: true
      )
    end

    describe '#create' do
      let(:path) { '/v2/apps' }

      it 'returns created app' do
        json_body = DropletKit::AppMapping.representation_for(:create, app)
        stub_do_api(path, :post).with(body: json_body).to_return(body: api_fixture('apps/find'), status: 200)

        expect(resource.create(app)).to match_app_fixture
      end
    end

    describe '#update' do
      let(:path) { '/v2/apps' }

      it 'returns updated app' do
        json_body = DropletKit::AppMapping.representation_for(:update, app)
        stub_do_api("/v2/apps/#{app_uuid}", :put).with(body: json_body).to_return(
          body: api_fixture('apps/find'), status: 200
        )

        expect(resource.update(app, id: app_uuid)).to match_app_fixture
      end
    end

    describe '#delete' do
      it 'returns the deleted app id' do
        stub_do_api("/v2/apps/#{app_uuid}", :delete).to_return(body: api_fixture('apps/delete'), status: 200)

        result = resource.delete(id: app_uuid)
        expect(result).to eq('{"id": "b7d64052-3706-4cb7-b21a-c5a2f44e63b3"}')
      end
    end
  end
end
