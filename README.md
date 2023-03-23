# DropletKit
[![Build Status](https://github.com/digitalocean/droplet_kit/workflows/CI/badge.svg?branch=main)](https://github.com/digitalocean/droplet_kit/actions)
[![Gem Version](https://badge.fury.io/rb/droplet_kit.svg)](https://badge.fury.io/rb/droplet_kit)

DropletKit is the official [DigitalOcean V2 API](https://developers.digitalocean.com/v2/) client. It supports everything the API can do with a simple interface written in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'droplet_kit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install droplet_kit

## Usage

You'll need to generate an access token in DigitalOcean's control panel at https://cloud.digitalocean.com/settings/applications

Using your access token, retrieve a client instance.

```ruby
require 'droplet_kit'
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
```

### Timeout

You may also set timeout and time to first byte options on the client.

```ruby
require 'droplet_kit'
client = DropletKit::Client.new(
  access_token: 'YOUR_TOKEN',
  open_timeout: 60, # time to first byte in seconds
  timeout:      120, # response timeout in seconds
)
```

### Custom User-Agent

If you would like to include a custom User-Agent header beyond what DropletKit
uses, you can pass one in at the client initialization like so:

```ruby
require 'droplet_kit'
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN', user_agent: 'custom')
```

## Design

DropletKit follows a strict design of resources as methods on your client. For examples, for droplets, you will call your client like this:

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
client.droplets #=> DropletsResource
```

DropletKit will return Plain Old Ruby objects(tm) that contain the information provided by the API. For actions that return multiple objects, the request won't be executed until the result is accessed. For example:

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')

# Returns an instance of a Paginated Resource.
client.droplets.all
# => #<DropletKit::PaginatedResource:0x000000010d556c3a>

# Returns the first Droplet.
client.droplets.all.first
# => <DropletKit::Droplet {:@id=>1, :@name=>"mydroplet", ...}>

# Returns an array of Droplet IDs.
client.droplets.all.map(&:id)
# => [1]
```

When you'd like to save objects, it's your responsibility to instantiate the objects and persist them using the resource objects. Let's use creating a Droplet as an example:

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
droplet = DropletKit::Droplet.new(name: 'mysite.com', region: 'nyc2', image: 'ubuntu-14-04-x64', size: 's-1vcpu-1gb')
created = client.droplets.create(droplet)
# => DropletKit::Droplet(id: 1231, name: 'something.com', ...)
```

To retrieve objects, you can perform this type of action on the resource (if the API supports it):

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
droplet = client.droplets.find(id: 123)
# => DropletKit::Droplet(id: 1231, name: 'something.com', ...)
```

# All Resources and actions.

## CDN resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.cdns #=> DropletKit::CertificateResource
cdn = DropletKit::CDN.new(
  origin: 'myspace.nyc3.digitaloceanspaces.com',
  ttl: 1800,
  custom_domain: 'www.myacme.xyz',
  certificate_id: 'a6689b98-2bb9-40be-8638-fb8426aabd26'
)
```

Actions supported:

* `client.cdns.find(id: 'id')`
* `client.cdns.all()`
* `client.cdns.create(cdn)`
* `client.cdns.update_ttl(id: 'id', ttl: 3600)`
* `client.cdns.update_custom_domain(id: 'id', custom_domain: 'www.myacme.xyz', certificate_id: 'a6689b98-2bb9-40be-8638-fb8426aabd26')`
* `client.cdns.flush_cache(id: 'id', files: ['*', 'path/to/css/*'])`
* `client.cdns.delete(id: 'id')`

## Certificate resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.certificates #=> DropletKit::CertificateResource
```

Actions supported:

* `client.certificates.find(id: 'id')`
* `client.certificates.all()`
* `client.certificates.create(certificate)`
* `client.certificates.delete(id: 'id')`

## Database resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.databases #=> DropletKit::DatabaseResource
database_cluster = DropletKit::DatabaseCluster.new(
  name: 'backend',
  engine: 'pg',
  version: '10',
  region: 'nyc3',
  size: 'db-s-2vcpu-4gb',
  num_nodes: 2,
  tags: ['production']
)
```

Actions supported:

* `client.databases.find_cluster(id: 'id')`
* `client.databases.all_clusters()`
* `client.databases.create_cluster(database_cluster)`
* `client.databases.resize_cluster(database_cluster, id: 'id')`
* `client.databases.migrate_cluster(database_cluster, id: 'id')`
* `client.databases.set_maintenance_window(database_maintenance_window, id: 'id')`
* `client.databases.update_maintenance_window(database_maintenance_window, id: 'id')`
* `client.databases.list_backups(id: 'id')`
* `client.databases.restore_from_backup(database_backup)`
* `client.databases.delete_cluster(id: 'id')`
* `client.database.create_db(database, id: 'id')`
* `client.databases.find_db(id: 'id', name: 'name')`
* `client.databases.all_dbs(id: 'id')`
* `client.databases.delete_db(id: 'id', name: 'name')`
* `client.databases.list_firewall_rules(id: 'id')`
* `client.databases.set_firewall_rules(database_firewall_rules, id: 'id')`
* `client.databases.create_read_only_replica(database_read_only_replica, id: 'id')`
* `client.databases.find_read_only_replica(id: 'id', name: 'name')`
* `client.databases.list_read_only_replicas(id: 'id')`
* `client.databases.delete_read_only_replica(id: 'id', name: 'name')`
* `client.databases.create_database_user(database_user, id: 'id')`
* `client.databases.find_database_user(id: 'id', name: 'name')`
* `client.databases.list_database_users(id: 'id')`
* `client.databases.reset_database_user_auth(reset_auth, id: 'id', name: 'name')`
* `client.databases.delete_database_user(id: 'id', name: 'name')`
* `client.databases.create_connection_pool(database_connection_pool, id: 'id')`
* `client.databases.find_connection_pool(id: 'id', name: 'name')`
* `client.databases.list_connection_pools(id: 'id')`
* `client.databases.delete_connection_pool(id: 'id', name: 'name')`
* `client.databases.set_eviction_policy(database_eviction_policy, id: 'id')`
* `client.databases.get_eviction_policy(id: 'id')`
* `client.databases.set_sql_mode(database_sql_mode, id: 'id')`
* `client.databases.get_sql_mode(id: 'id')`

## Droplet resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.droplets #=> DropletKit::DropletResource
```

Actions supported:

* `client.droplets.all()`
* `client.droplets.all(tag_name: 'tag_name')`
* `client.droplets.find(id: 'id')`
* `client.droplets.create(droplet)`
* `client.droplets.create_multiple(droplet)`
* `client.droplets.delete(id: 'id')`
* `client.droplets.delete_for_tag(tag_name: 'tag_name')`
* `client.droplets.kernels(id: 'id')`
* `client.droplets.snapshots(id: 'id')`
* `client.droplets.backups(id: 'id')`
* `client.droplets.actions(id: 'id')`

## Droplet Action resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.droplet_actions #=> DropletKit::DropletAction
```

Actions supported:

* `client.droplet_actions.reboot(droplet_id: droplet.id)`
* `client.droplet_actions.power_cycle(droplet_id: droplet.id)`
* `client.droplet_actions.power_cycle_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.shutdown(droplet_id: droplet.id)`
* `client.droplet_actions.shutdown_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.power_off(droplet_id: droplet.id)`
* `client.droplet_actions.power_off_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.power_on(droplet_id: droplet.id)`
* `client.droplet_actions.power_on_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.password_reset(droplet_id: droplet.id)`
* `client.droplet_actions.enable_ipv6(droplet_id: droplet.id)`
* `client.droplet_actions.enable_ipv6_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.enable_backups(droplet_id: droplet.id)`
* `client.droplet_actions.enable_backups_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.disable_backups(droplet_id: droplet.id)`
* `client.droplet_actions.disable_backups_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.upgrade(droplet_id: droplet.id)`
* `client.droplet_actions.enable_private_networking(droplet_id: droplet.id)`
* `client.droplet_actions.enable_private_networking_for_tag(tag_name: 'tag_name')`
* `client.droplet_actions.snapshot(droplet_id: droplet.id, name: 'Snapshot Name')`
* `client.droplet_actions.snapshot_for_tag(tag_name: 'tag_name', name: 'Snapshot Name')`
* `client.droplet_actions.change_kernel(droplet_id: droplet.id, kernel: 'kernel_id')`
* `client.droplet_actions.rename(droplet_id: droplet.id, name: 'New-Droplet-Name')`
* `client.droplet_actions.rebuild(droplet_id: droplet.id, image: 'image_id')`
* `client.droplet_actions.restore(droplet_id: droplet.id, image: 'image_id')`
* `client.droplet_actions.resize(droplet_id: droplet.id, size: 's-1vcpu-1gb')`
* `client.droplet_actions.find(droplet_id: droplet.id, id: action.id)`
* `client.droplet_actions.action_for_id(droplet_id: droplet.id, type: 'event_name', param: 'value')`
* `client.droplet_actions.action_for_tag(tag_name: 'tag_name', type: 'event_name', param: 'value')`

## Domain resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.domains #=> DropletKit::DomainResource
```

Actions supported:

* `client.domains.all()`
* `client.domains.create(domain)`
* `client.domains.find(name: 'name')`
* `client.domains.delete(name: 'name')`


## Domain record resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.domain_records #=> DropletKit::DomainRecordResource
domain_record = DropletKit::DomainRecord.new(
  type: 'CNAME',
  name: 'www',
  data: '@',
  ttl: 1800
)
```

Actions supported:

* `client.domain_records.all(for_domain: 'for_domain')`
* `client.domain_records.create(domain_record, for_domain: 'for_domain')`
* `client.domain_records.find(for_domain: 'for_domain', id: 'id')`
* `client.domain_records.delete(for_domain: 'for_domain', id: 'id')`
* `client.domain_records.update(domain_record, for_domain: 'for_domain', id: 'id')`

## Firewall resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.firewalls #=> DropletKit::FirewallResource

inbound_rule = DropletKit::FirewallInboundRule.new(
  protocol: 'icmp',
  ports: '0',
  sources: {
    tags: ['frontend', 'backend'],
    load_balancer_uids: ['d2d3920a-9d45-41b0-b018-d15e18ec60a4'],
    kubernetes_ids: ['a47b6fb1-4791-4b29-aae1-2b1b9f68a2da']
  }
)

outbound_rule = DropletKit::FirewallOutboundRule.new(
  protocol: 'icmp',
  ports: '0',
  destinations: {
    addresses: ["127.0.0.0"],
    droplet_ids: [456, 789]
  }
)

firewall = DropletKit::Firewall.new(
  name: 'firewall',
  inbound_rules: [
    inbound_rule
  ],
  outbound_rules: [
    outbound_rule
  ],
  droplet_ids: [123],
  tags: ['backend']
)
```

Actions supported:

* `client.firewalls.find(id: 'id')`
* `client.firewalls.create(firewall)`
* `client.firewalls.update(firewall, id: 'id')`
* `client.firewalls.all()`
* `client.firewalls.all_by_droplet(droplet_id: 'id')`
* `client.firewalls.delete(id: 'id')`
* `client.firewalls.add_droplets([droplet.id], id: 'id')`
* `client.firewalls.remove_droplets([droplet.id], id: 'id')`
* `client.firewalls.add_tags([tag.name], id: 'id')`
* `client.firewalls.remove_tags([tag.name], id: 'id')`
* `client.firewalls.add_rules(inbound_rules: [inbound_rule], outbound_rules: [outbound_rule], id: 'id')`
* `client.firewalls.remove_rules(inbound_rules: [inbound_rule], outbound_rules: [outbound_rule], id: 'id')`


## Image resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.images #=> DropletKit::ImageResource
```

Actions supported:

* `client.images.all()`
* `client.images.find(id: 'id')`
* `client.images.delete(id: 'id')`
* `client.images.update(image, id: 'id')`


## Image Action Resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.image_actions #=> DropletKit::ImageActionResource
```

Image Actions Supported:

* `client.image_actions.all(image_id: 123)`
* `client.image_actions.find(image_id: 123, id: 123455)`
* `client.image_actions.transfer(image_id: 123, region: 'nyc3')`

## Invoice resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.invoices #=> DropletKit::InvoiceResource
```

Actions supported:

* `client.invoices.list()`
* `client.invoices.find(id:123)`

## Kubernetes Resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.kubernetes_clusters #=> DropletKit::KubernetesClusterResource
```

Actions supported

When the arguments below refer to cluster, they refer to:
```
cluster = DropletKit::KubernetesCluster.new(name: "foo", region: "nyc1", ...) # cluster attributes
```

When the arguments below refer to node_pool, they refer to:
```
node_pool = DropletKit::KubernetesNodePool.new(name: 'frontend', size: 's-1vcpu-1gb', count: 3, ...) # Node Pool attributes
```

* `client.kubernetes_clusters.all()`
* `client.kubernetes_clusters.find(id: 'cluster_id')`
* `client.kubernetes_clusters.create(cluster)`
* `client.kubernetes_clusters.kubeconfig(id: 'cluster_id')`
* `client.kubernetes_clusters.update(cluster, id: 'cluster_id')`
* `client.kubernetes_clusters.delete(id: 'cluster_id')`
* `client.kubernetes_clusters.node_pools(id: 'cluster_id')`
* `client.kubernetes_clusters.find_node_pool(id: 'cluster_id', pool_id: 'node_pool_id')`
* `client.kubernetes_clusters.create_node_pool(node_pool, id: 'cluster_id')`
* `client.kubernetes_clusters.update_node_pool(node_pool, id: 'cluster_id', pool_id: 'node_pool_id')`
* `client.kubernetes_clusters.delete_node_pool(id: 'cluster_id', pool_id: 'node_pool_id')`
* `client.kubernetes_clusters.recycle_node_pool([node_id, node_id, ...], id: 'cluster_id', pool_id: 'node_pool_id')`
* `client.kubernetes_options.all()`


## Load balancer resource
```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.load_balancers #=> DropletKit::LoadBalancerResource
```

Actions supported:

* `client.load_balancers.find(id: 'id')`
* `client.load_balancers.all()`
* `client.load_balancers.create(load_balancer)`
* `client.load_balancers.update(load_balancer, id: 'id')`
* `client.load_balancers.delete(id: 'id')`
* `client.load_balancers.add_droplets([droplet.id], id: 'id')`
* `client.load_balancers.remove_droplets([droplet.id], id: 'id')`
* `client.load_balancers.add_forwarding_rules([forwarding_rule], id: 'id')`
* `client.load_balancers.remove_forwarding_rules([forwarding_rule], id: 'id')`


## Region resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.regions #=> DropletKit::RegionResource
```

Actions supported:

* `client.regions.all()`


## Size resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.sizes #=> DropletKit::SizeResource
```

Actions supported:

* `client.sizes.all()`


## SSH key resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.ssh_keys #=> DropletKit::SSHKeyResource
```

When you want to create a droplet using your stored SSH key.

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
my_ssh_keys = client.ssh_keys.all.collect {|key| key.fingerprint}
droplet = DropletKit::Droplet.new(name: 'mysite.com', region: 'nyc2', image: 'ubuntu-14-04-x64', size: 's-1vcpu-1gb', ssh_keys: my_ssh_keys)
created = client.droplets.create(droplet)
# => DropletKit::Droplet(id: 1231, name: 'something.com', ...)
```

Actions supported:

* `client.ssh_keys.all()`
* `client.ssh_keys.create(ssh_key)`
* `client.ssh_keys.find(id: 'id')`
* `client.ssh_keys.delete(id: 'id')`
* `client.ssh_keys.update(ssh_key, id: 'id')`

## Project resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.projects #=> DropletKit::ProjectResource
```

Actions supported:

* `client.projects.all()`
* `client.projects.find(id: 'id')`
* `client.projects.find_default` is equivalent to `client.projects.find(id: DropletKit::Project::DEFAULT)`
* `client.projects.create(DropletKit::Project.new(name: 'name', purpose: 'Service or API'))`
* `client.projects.update(project, id: 'id')`
* `client.projects.delete(id: 'id')`
* `client.projects.list_resources(id: 'id')`
* `client.projects.assign_resources([DropletKit::Droplet.new(id: 123), "do:space:myspace.com"], id: 'id')`

## Tag resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.tags #=> DropletKit::TagResource
```

Actions supported:

* `client.tags.all()`
* `client.tags.find(name: 'name')`
* `client.tags.create(DropletKit::Tag.new(name: 'name'))`
* `client.tags.delete(name: 'name')`
* `client.tags.tag_resources(name: 'name', resources: [{ resource_id => 'droplet_id', resource_type: 'droplet' },{ resource_id => 'image_id', resource_type: 'image' }])`
* `client.tags.untag_resources(name 'name', resources: [{ resource_id => 'droplet_id', resource_type: 'droplet' },{ resource_id => 'image_id', resource_type: 'image' }])`

## Account resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.account #=> DropletKit::AccountResource
```

Actions supported:

* `client.account.info()`

## Balance resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.balance #=> DropletKit::BalanceResource
```

Actions supported:

* `client.balance.info()`

## Reserved IP resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.reserved_ips #=> DropletKit::ReservedIpResource

Actions supported:

* `client.reserved_ips.all()`
* `client.reserved_ips.find(ip: 'ip address')`
* `client.reserved_ips.create(reserved_ip)`
* `client.reserved_ips.delete(ip: 'ip address')`

## Reserved IP Action resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.reserved_ip_actions #=> DropletKit::ReservedIpActionResource

Actions supported:

* `client.reserved_ip_actions.assign(ip: reserved_ip.ip, droplet_id: droplet.id)`
* `client.reserved_ip_actions.unassign(ip: reserved_ip.ip)`

## Volume resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.volumes #=> DropletKit::VolumeResource

Actions supported:

* `client.volumes.all()`
* `client.volumes.find(id: 'id')`
* `client.volumes.create(volume)`
* `client.volumes.snapshots(id: 'id')`
* `client.volumes.create_snapshot(id: 'id', name: 'snapshot-name')`
* `client.volumes.delete(id: 'id')`


## Volume Action resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.volume_actions #=> DropletKit::VolumeActionResource

Actions supported:

* `client.volume_actions.attach(volume_id: volume.id, droplet_id: droplet.id, region: droplet.region.slug)`
* `client.volume_actions.detach(volume_id: volume.id, droplet_id: droplet.id, region: droplet.region.slug)`
* `client.volume_actions.resize(volume_id: volume.id, size_gigabytes: 123, region: droplet.region.slug)`

## Snapshot resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.snapshots #=> DropletKit::SnapshotResource

Actions supported:

* `client.snapshots.all(resource_type: 'droplet')`
* `client.snapshots.find(id: 'id')`
* `client.snapshots.delete(id: 'id')`

## VPC resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.vpcs #=> DropletKit::VPCResource

Actions supported:

* `client.vpcs.find(id: 'id')`
* `client.vpcs.all()`
* `client.vpcs.create(vpc)`
* `client.vpcs.update(vpc, id: 'id')`
* `client.vpcs.patch(vpc, id: 'id')`
* `client.vpcs.delete(id: 'id')`
* `client.vpcs.all_members(id: 'id')`

## Container Registry resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.container_registry #=> DropletKit::ContainerRegistryResource

Actions supported:

* `client.container_registry.get()`
* `client.container_registry.create(registry)`
* `client.container_registry.delete()`
* `client.container_registry.docker_credentials()`

## Container Registry Repository resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.container_registry_repository #=> DropletKit::ContainerRegistryRepositoryResource

Actions supported:

* `client.container_registry_repository.all(registry_name: 'registry')`
* `client.container_registry_repository.tags(registry_name: 'registry', repository: 'repo')`
* `client.container_registry_repository.delete_tag(registry_name: 'registry', repository: 'repo', tag: 'tag')`
* `client.container_registry_repository.delete_manifest(registry_name: 'registry', repository: 'repo', manifest_digest: 'sha256:cb8a924afdf0229ef7515d9e5b3024e23b3eb03ddbba287f4a19c6ac90b8d221')`

## Contributing

1. Fork it ( https://github.com/digitalocean/droplet_kit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Releasing
See [RELEASE](RELEASE.md) for details
