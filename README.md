# DropletKit

DropletKit is the official [DigitalOcean V2 API](https://developers.digitalocean.com/v2/) client. It supports everything the API can do with a simple interface written in Ruby.

[![Build Status](https://travis-ci.org/digitalocean/droplet_kit.svg?branch=master)](https://travis-ci.org/digitalocean/droplet_kit)

## Installation

Add this line to your application's Gemfile:

    gem 'droplet_kit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install droplet_kit

## Usage

You'll need to generate an access token in Digital Ocean's control panel at https://cloud.digitalocean.com/settings/applications

With your access token, retrieve a client instance with it.

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
```

## Design

DropletKit follows a strict design of resources as methods on your client. For examples, for droplets, you will call your client like this:

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
client.droplets #=> DropletsResource
```

DropletKit will return Plain Old Ruby objects(tm) that contain the information provided by the API. For example:

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
client.droplets.all
# => [ DropletKit::Droplet(id: 123, name: 'something.com', ...), DropletKit::Droplet(id: 1066, name: 'bunk.com', ...) ]
```

When you'd like to save objects, it's your responsibility to instantiate the objects and persist them using the resource objects. Let's use creating a Droplet as an example:

```ruby
client = DropletKit::Client.new(access_token: 'YOUR_TOKEN')
droplet = DropletKit::Droplet.new(name: 'mysite.com', region: 'nyc2', image: 'ubuntu-14-04-x64', size: '512mb')
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
* `client.droplet_actions.resize(droplet_id: droplet.id, size: '1gb')`
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
    load_balancer_uids: ['d2d3920a-9d45-41b0-b018-d15e18ec60a4']
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

```
client = DropletKit::Client.new(access_token: 'TOKEN')
client.image_actions #=> DropletKit::ImageActionResource
```

Image Actions Supported:

* `client.image_actions.all(image_id: 123)`
* `client.image_actions.find(image_id: 123, id: 123455)`
* `client.image_actions.transfer(image_id: 123, region: 'nyc3')`


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
droplet = DropletKit::Droplet.new(name: 'mysite.com', region: 'nyc2', image: 'ubuntu-14-04-x64', size: '512mb', ssh_keys: my_ssh_keys)
created = client.droplets.create(droplet)
# => DropletKit::Droplet(id: 1231, name: 'something.com', ...)
```

Actions supported:

* `client.ssh_keys.all()`
* `client.ssh_keys.create(ssh_key)`
* `client.ssh_keys.find(id: 'id')`
* `client.ssh_keys.delete(id: 'id')`
* `client.ssh_keys.update(ssh_key, id: 'id')`

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
* `client.tags.tag_resources(name: 'name', resources: [{ resource_id => 'droplet_id', resource_type: 'droplet' }])`
* `client.tags.untag_resources(name 'name', resources: [{ resource_id => 'droplet_id', resource_type: 'droplet' }])`

## Account resource

```ruby
client = DropletKit::Client.new(access_token: 'TOKEN')
client.account #=> DropletKit::AccountResource
```

Actions supported:

* `client.account.info()`


## Floating IP resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.floating_ips #=> DropletKit::FloatingIpResource

Actions supported:

* `client.floating_ips.all()`
* `client.floating_ips.find(ip: 'ip address')`
* `client.floating_ips.create(floating_ip)`
* `client.floating_ips.delete(ip: 'ip address')`

## Floating IP Action resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.floating_ip_actions #=> DropletKit::FloatingIpActionResource

Actions supported:

* `client.floating_ip_actions.assign(ip: floating_ip.ip, droplet_id: droplet.id)`
* `client.floating_ip_actions.unassign(ip: floating_ip.ip)`

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

## Volume resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.snapshots #=> DropletKit::SnapshotResource

Actions supported:

* `client.snapshots.all(resource_type: 'droplet')`
* `client.snapshots.find(id: 'id')`
* `client.snapshots.delete(id: 'id')`

## Contributing

1. Fork it ( https://github.com/digitalocean/droplet_kit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Releasing

Bump the [version](https://github.com/digitalocean/droplet_kit/blob/master/lib/droplet_kit/version.rb), add all changes
that are being released to the [CHANGELOG](https://github.com/digitalocean/droplet_kit/blob/master/CHANGELOG.md) and
if you have already done the rubygems sign in from the account, just run `rake release`, if not continue reading.

Find the password on DO's lastpass account (search for rubygems), sign in with the user (run gem `gem push` and it
will ask you for DO's email and password you found on lastpass), the `gem push` command will fail, ignore. Now just run
`rake release` and the gem will be pushed to rubygems.
