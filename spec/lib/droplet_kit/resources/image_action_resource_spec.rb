require 'spec_helper'

RSpec.describe DropletKit::ImageActionResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#transfer' do
    it 'sends a transfer request for an image' do
      request = stub_do_api('/v2/images/449676391/actions').with(
        body: { type: 'transfer', region: 'sfo1' }.to_json
      ).to_return(body: api_fixture('image_actions/create'), status: 201)

      action = resource.transfer(image_id: 449676391, region: 'sfo1')

      expect(request).to have_been_made

      expect(action).to be_kind_of(DropletKit::ImageAction)
      expect(action.id).to eq(23)
      expect(action.status).to eq("in-progress")
      expect(action.type).to eq("transfer")
      expect(action.started_at).to eq("2014-08-05T15:15:28Z")
      expect(action.completed_at).to eq(nil)
      expect(action.resource_id).to eq(449676391)
      expect(action.resource_type).to eq("image")
      expect(action.region).to eq("nyc1")
      expect(action.region_slug).to eq("nyc1")
    end
  end

  describe '#all' do
    it 'returns all of the image actions via a paginated resources' do
      request = stub_do_api('/v2/images/449676391/actions', :get).to_return(
        body: api_fixture('image_actions/all'),
        status: 200
      )

      actions = resource.all(image_id: 449676391).take(20)

      expect(request).to have_been_made

      expect(actions.size).to be(2)

      action = actions.first

      expect(action.id).to eq(298374)
      expect(action.status).to eq("completed")
      expect(action.type).to eq("image_destroy")
      expect(action.started_at).to eq("2014-10-28T17:11:05Z")
      expect(action.completed_at).to eq("2014-10-28T17:11:06Z")
      expect(action.resource_id).to eq(45646587)
      expect(action.resource_type).to eq("image")
      expect(action.region).to eq(nil)
      expect(action.region_slug).to eq(nil)
    end
  end

  describe '#find' do
    it 'returns a single action' do
      stub_do_api('/v2/images/449676391/actions/23').to_return(body: api_fixture('image_actions/find'))
      action = resource.find(image_id: 449676391, id: 23)

      expect(action).to be_kind_of(DropletKit::ImageAction)
      expect(action.id).to eq(23)
      expect(action.status).to eq("in-progress")
      expect(action.type).to eq("transfer")
      expect(action.started_at).to eq("2014-08-05T15:15:28Z")
      expect(action.completed_at).to eq(nil)
      expect(action.resource_id).to eq(449676391)
      expect(action.resource_type).to eq("image")
      expect(action.region).to eq("nyc1")
      expect(action.region_slug).to eq("nyc1")
    end
  end
end
