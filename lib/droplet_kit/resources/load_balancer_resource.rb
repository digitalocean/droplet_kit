module DropletKit
  class LoadBalancerResource < ResourceKit::Resource
    include ErrorHandlingResourcable

    resources do
      action :find, 'GET /v2/load_balancers/:id' do
        handler(200) { |response| LoadBalancerMapping.extract_single(response.body, :read) }
      end

      action :all, 'GET /v2/load_balancers' do
        query_keys :per_page, :page
        handler(200) { |response| LoadBalancerMapping.extract_collection(response.body, :read) }
      end

      action :create, 'POST /v2/load_balancers' do
        body { |load_balancer| LoadBalancerMapping.representation_for(:create, load_balancer) }
        handler(202) { |response| LoadBalancerMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedCreate, response.body) }
      end

      action :update, 'PUT /v2/load_balancers/:id' do
        body {|load_balancer| LoadBalancerMapping.representation_for(:update, load_balancer) }
        handler(200) { |response| LoadBalancerMapping.extract_single(response.body, :read) }
        handler(422) { |response| ErrorMapping.fail_with(FailedUpdate, response.body) }
      end

      action :delete, 'DELETE /v2/load_balancers/:id' do
        handler(204) { |_| true }
      end

      action :add_droplets, 'POST /v2/load_balancers/:id/droplets' do
        body { |droplet_ids| { droplet_ids: droplet_ids }.to_json }
        handler(204) { |_| true }
      end

      action :remove_droplets, 'DELETE /v2/load_balancers/:id/droplets' do
        body { |droplet_ids| { droplet_ids: droplet_ids }.to_json }
        handler(204) { |_| true }
      end

      action :add_forwarding_rules, 'POST /v2/load_balancers/:id/forwarding_rules' do
        body { |forwarding_rules| ForwardingRuleMapping.represent_collection_for(:create, forwarding_rules) }
        handler(204) { |_| true }
      end

      action :remove_forwarding_rules, 'DELETE /v2/load_balancers/:id/forwarding_rules' do
        body { |forwarding_rules| ForwardingRuleMapping.represent_collection_for(:update, forwarding_rules) }
        handler(204) { |_| true }
      end
    end

    def all(*args)
      PaginatedResource.new(action(:all), self, *args)
    end
  end
end
