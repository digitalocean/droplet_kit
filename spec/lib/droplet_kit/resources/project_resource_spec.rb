# frozen_string_literal: true

require 'spec_helper'

describe DropletKit::ProjectResource do
  subject(:resource) { described_class.new(connection: connection) }

  include_context 'resources'

  RSpec::Matchers.define :match_project_fixture do |expected|
    match do |actual|
      expect(actual).to be_kind_of(DropletKit::Project)
      expect(actual.name).to eq('cloud.digitalocean.com')
      expect(actual.id).to eq('c177dc8c-12c1-4483-af1c-877eed0f14cb')
      expect(actual.owner_uuid).to eq('34fc5c195b417b7157649f6b8ae273ae9b1b2970')
      expect(actual.owner_id).to eq(123)
      expect(actual.description).to eq('Our control panel')
      expect(actual.purpose).to eq('Web Application')
      expect(actual.environment).to eq('Production')
      expect(actual.is_default).to be_falsey
      expect(actual.created_at).to be_present
      expect(actual.updated_at).to be_present
    end
  end
  describe '#all' do
    it 'returns all of the projects' do
      stub_do_api('/v2/projects', :get)
        .to_return(body: api_fixture('projects/all'))
      projects = resource.all

      expect(projects).to all(be_kind_of(DropletKit::Project))
      expect(projects.collection.size).to eq(2)

      default = projects[0]
      expect(default.name).to eq('digitalocean')
      expect(default.id).to eq('ec104091-d6d3-41b6-b803-780156de20ae')
      expect(default.owner_uuid).to eq('34fc5c195b417b7157649f6b8ae273ae9b1b2970')
      expect(default.owner_id).to eq(123)
      expect(default.description).to eq('Update your project information under Settings')
      expect(default.purpose).to be_empty
      expect(default.environment).to be_empty
      expect(default.is_default).to be_truthy
      expect(default.created_at).to be_present
      expect(default.updated_at).to be_present

      cloud = projects[1]
      expect(cloud).to match_project_fixture
    end

    context 'when empty' do
      it 'returns an empty array of projects' do
        stub_do_api('/v2/projects', :get)
          .to_return(body: api_fixture('projects/all_empty'))
        projects = resource.all.map(&:id)

        expect(projects).to be_empty
      end
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'projects/all' }
      let(:api_path) { '/v2/projects' }
    end
  end

  describe '#find' do
    it 'returns a singular tag' do
      stub_do_api('/v2/projects/c177dc8c-12c1-4483-af1c-877eed0f14cb', :get)
        .to_return(body: api_fixture('projects/find'))

      project = resource.find(id: 'c177dc8c-12c1-4483-af1c-877eed0f14cb')

      expect(project).to match_project_fixture
    end
  end

  describe '#create' do
    it 'returns the created project' do
      project = DropletKit::Project.new(name: 'cloud.digitalocean.com', description: 'Our control panel', purpose: 'Web Application', environment: 'Production')

      as_string = DropletKit::ProjectMapping.representation_for(:create, project)

      stub_do_api('/v2/projects', :post).with(body: as_string)
                                        .to_return(body: api_fixture('projects/find'), status: 201)
      created_project = resource.create(project)

      expect(created_project).to match_project_fixture
    end
  end

  describe '#delete' do
    it 'deletes a project' do
      request = stub_do_api('/v2/projects/c177dc8c-12c1-4483-af1c-877eed0f14cb', :delete)
                .to_return(body: '', status: 204)

      resource.delete(id: 'c177dc8c-12c1-4483-af1c-877eed0f14cb')
      expect(request).to have_been_made
    end
  end

  describe '#list_resources' do
    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'projects/resources' }
      let(:api_path) { '/v2/projects/c177dc8c-12c1-4483-af1c-877eed0f14cb/resources' }
    end

    it 'list resources in the specified project' do
      stub_do_api('/v2/projects/c177dc8c-12c1-4483-af1c-877eed0f14cb/resources', :get)
        .to_return(body: api_fixture('projects/resources'), status: 200)

      resources = resource.list_resources(id: 'c177dc8c-12c1-4483-af1c-877eed0f14cb')

      expect(resources.to_a.size).to eq(10)
      resources.each do |resource|
        expect(resource[:urn]).to start_with('do:')
        expect(resource[:self_link]).not_to be_empty
      end

      objects = resources.map(&:to_model)
      expect(objects.first).to be_nil # Can't map spaces
      droplets = objects[1..-1]
      droplets.each do |droplet|
        expect(droplet).to be_a(DropletKit::Droplet)
        expect(droplet.id).not_to be_empty
      end
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) { 'projects/resources' }
      let(:api_path) { '/v2/projects/c177dc8c-12c1-4483-af1c-877eed0f14cb/resources' }
    end
  end

  describe '#assign_resources' do
    it 'calls the api when passing a valid urn' do
      request = stub_do_api('/v2/projects/:id/resources', :post)
                .to_return(body: '', status: 201)

      resource.assign_resources(['do:droplet:123'])
      expect(request).to have_been_made
    end

    it 'calls the api when passing a model than can be converted to urn' do
      request = stub_do_api('/v2/projects/:id/resources', :post)
                .to_return(body: '', status: 201)

      resource.assign_resources([DropletKit::Droplet.new(id: 123)])
      expect(request).to have_been_made
    end

    it 'raises an error when the resouce cannot be assigned' do
      expect {
        resource.assign_resources(['invalid'])
      }.to raise_error(DropletKit::Error, 'cannot assign resource without valid urn: invalid')
    end
  end
end
