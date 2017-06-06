module DropletKit
  class FirewallResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find, 'GET /v2/firewalls/:id' do
        handler(200) { |response| FirewallMapping.extract_single(response.body, :read) }
      end

      action :create, 'POST /v2/firewalls' do
        body { |firewall| FirewallMapping.representation_for(:create, firewall) }
        handler(202) { |response| FirewallMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update, 'PUT /v2/firewalls/:id' do
        body { |firewall| FirewallMapping.representation_for(:update, firewall) }
        handler(200) { |response| FirewallMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :all, 'GET /v2/firewalls' do
        query_keys :per_page, :page
        handler(200) { |response| FirewallMapping.extract_collection(response.body, :read) }
      end

      action :all_by_droplet, 'GET /v2/droplets/:droplet_id/firewalls' do
        query_keys :per_page, :page
        handler(200) { |response| FirewallMapping.extract_collection(response.body, :read) }
      end

      action :delete, 'DELETE /v2/firewalls/:id' do
        handler(204) { |_| true }
      end

      action :add_droplets, 'POST /v2/firewalls/:id/droplets' do
        body { |droplet_ids| { droplet_ids: droplet_ids }.to_json }
        handler(204) { |_| true }
      end

      action :remove_droplets, 'DELETE /v2/firewalls/:id/droplets' do
        body { |droplet_ids| { droplet_ids: droplet_ids }.to_json }
        handler(204) { |_| true }
      end

      action :add_tags, 'POST /v2/firewalls/:id/tags'  do
        body { |tags| { tags: tags}.to_json }
        handler(204) { |_| true }
      end

      action :remove_tags, 'DELETE /v2/firewalls/:id/tags' do
        body { |tags| { tags: tags}.to_json }
        handler(204) { |_| true }
      end

      action :add_rules, 'POST /v2/firewalls/:id/rules' do
        body do |rules|
          DropletKit::FirewallRuleMapping
            .representation_for(:create,
                                FirewallRule.new(inbound_rules: rules[:inbound_rules],
                                                 outbound_rules: rules[:outbound_rules]))
        end
        handler(204) { |_| true }
      end

      action :remove_rules, 'DELETE /v2/firewalls/:id/rules' do
        body do |rules|
          DropletKit::FirewallRuleMapping
            .representation_for(:update,
                                FirewallRule.new(inbound_rules: rules[:inbound_rules],
                                                 outbound_rules: rules[:outbound_rules]))
        end
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end

    def all_by_droplet(*args)
      PaginatedResource.new(action(:all_by_droplet), self, *args)
    end
  end
end
