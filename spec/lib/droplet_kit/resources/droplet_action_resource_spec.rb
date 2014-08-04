require 'spec_helper'

RSpec.describe DropletKit::DropletActionResource do
  subject(:resource) { described_class.new(connection) }
  let(:droplet_id) { 1066 }
  def json
    {
      "action" => {
        "id" => 2,
        "status" => "in-progress",
        "type" => action,
        "started_at" => "2014-07-29T14:35:27Z",
        "completed_at" => nil,
        "resource_id" => 12,
        "resource_type" => "droplet",
        "region" => "nyc1"
      }
    }.to_json
  end

  include_context 'resources'

  ACTIONS_WITHOUT_INPUT = %w(reboot power_cycle shutdown power_off
    power_on password_reset enable_ipv6 disable_backups enable_private_networking)

  ACTIONS_WITHOUT_INPUT.each do |action_name|
    describe "Action #{action_name}" do
      let(:action) { action_name }

      it 'performs the action' do
        request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
          body: { type: action_name }.to_json
        ).to_return(body: json, status: 201)

        returned_action = resource.send(action_name, droplet_id: droplet_id)

        expect(request).to have_been_made
        expect(returned_action.type).to eq(action_name)
      end
    end
  end

  describe "Action snapshot" do
    let(:action) { 'snapshot' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, name: 'Dwight' }.to_json
      ).to_return(body: json, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, name: 'Dwight')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action kernel" do
    let(:action) { 'kernel' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, kernel: 1556 }.to_json
      ).to_return(body: json, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, kernel: 1556)

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action rename" do
    let(:action) { 'rename' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, name: 'newname.com' }.to_json
      ).to_return(body: json, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, name: 'newname.com')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action rebuild" do
    let(:action) { 'rebuild' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, image: 'ubuntu-14-04-x86' }.to_json
      ).to_return(body: json, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, image: 'ubuntu-14-04-x86')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action restore" do
    let(:action) { 'restore' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, image: 'ubuntu-14-04-x86' }.to_json
      ).to_return(body: json, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, image: 'ubuntu-14-04-x86')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end

  describe "Action resize" do
    let(:action) { 'resize' }

    it 'performs the action' do
      request = stub_do_api("/v2/droplets/#{droplet_id}/actions", :post).with(
        body: { type: action, size: '1gb' }.to_json
      ).to_return(body: json, status: 201)

      returned_action = resource.send(action, droplet_id: droplet_id, size: '1gb')

      expect(request).to have_been_made
      expect(returned_action.type).to eq(action)
    end
  end
end