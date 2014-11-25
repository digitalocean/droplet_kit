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

DropletKit follows a strict design of resoures as methods on your client. For examples, for droplets, you will call your client like this:

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

When you'd like to save objects, it's your responsibility to instantiate the objects and persist them using the resource objects. Lets use creating a Droplet as an example:

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

## Droplet resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.droplets #=> DropletKit::DropletResource

Actions supported:

* `client.droplets.all()`
* `client.droplets.find(id: 'id')`
* `client.droplets.create(droplet)`
* `client.droplets.delete(id: 'id')`
* `client.droplets.kernels(id: 'id')`
* `client.droplets.snapshots(id: 'id')`
* `client.droplets.backups(id: 'id')`

Parameters supported:

* **access_token** `your API access token`
* **name** `the name of your droplet`
* **region** `your droplet's region, nyc1 etc.`
* **size** `your droplet's size, 512mb etc.`
* **image** `the image you wish to create, ubuntu-14-04-x86 etc.`
* **ssh_keys** `An array containing your SSH key IDs, [123]`
* **backups** `boolean value of whether you want to enable backups or not`
* **ipv6** `boolean for enabling ipv6 support`
* **private_networking** `boolean for enabling private networking`
* **user_data** `a string containing custom commands to run "#cloud-config\nruncmd\n\t- echo 'Hello!'"`

## Droplet Action resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.droplet_actions #=> DropletKit::DropletAction

Actions supported:

* `client.droplet_actions.reboot(droplet_id: droplet.id)`
* `client.droplet_actions.power_cycle(droplet_id: droplet.id)`
* `client.droplet_actions.shutdown(droplet_id: droplet.id)`
* `client.droplet_actions.power_off(droplet_id: droplet.id)`
* `client.droplet_actions.power_on(droplet_id: droplet.id)`
* `client.droplet_actions.password_reset(droplet_id: droplet.id)`
* `client.droplet_actions.enable_ipv6(droplet_id: droplet.id)`
* `client.droplet_actions.disable_backups(droplet_id: droplet.id)`
* `client.droplet_actions.enable_private_networking(droplet_id: droplet.id)`
* `client.droplet_actions.snapshot(droplet_id: droplet.id, name: 'Snapshot Name')`
* `client.droplet_actions.change_kernel(droplet_id: droplet.id, kernel: 'kernel_id')`
* `client.droplet_actions.rename(droplet_id: droplet.id, name: 'New-Droplet-Name')`
* `client.droplet_actions.rebuild(droplet_id: droplet.id, image: 'image_id')`
* `client.droplet_actions.restore(droplet_id: droplet.id, image: 'image_id')`
* `client.droplet_actions.resize(droplet_id: droplet.id, size: '1gb')`
* `client.droplet_actions.find(droplet_id: droplet.id, id: action.id)`

## Domain resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.domains #=> DropletKit::DomainResource

Actions supported:

* `client.domains.all()`
* `client.domains.create(domain)`
* `client.domains.find(name: 'name')`
* `client.domains.delete(name: 'name')`


## Domain record resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.domain_records #=> DropletKit::DomainRecordResource

Actions supported:

* `client.domain_records.all(for_domain: 'for_domain')`
* `client.domain_records.create(domain_record, for_domain: 'for_domain')`
* `client.domain_records.find(for_domain: 'for_domain', id: 'id')`
* `client.domain_records.delete(for_domain: 'for_domain', id: 'id')`
* `client.domain_records.update(domain_record, for_domain: 'for_domain', id: 'id')`


## Image resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.images #=> DropletKit::ImageResource

Actions supported:

* `client.images.all()`
* `client.images.find(id: 'id')`
* `client.images.delete(id: 'id')`
* `client.images.update(image, id: 'id')`


## Image Action Resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.image_actions #=> DropletKit::ImageActionResource

Image Actions Supported:

* `client.image_actions.all(image_id: 123)`
* `client.image_actions.find(image_id: 123, id: 123455)`
* `client.image_actions.transfer(image_id: 123, region: 'nyc3')`


## Region resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.regions #=> DropletKit::RegionResource

Actions supported:

* `client.regions.all()`


## Size resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.sizes #=> DropletKit::SizeResource

Actions supported:

* `client.sizes.all()`


## Ssh key resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.ssh_keys #=> DropletKit::SSHKeyResource

Actions supported:

* `client.ssh_keys.all()`
* `client.ssh_keys.create(ssh_key)`
* `client.ssh_keys.find(id: 'id')`
* `client.ssh_keys.delete(id: 'id')`
* `client.ssh_keys.update(ssh_key, id: 'id')`

## Account resource

    client = DropletKit::Client.new(access_token: 'TOKEN')
    client.account #=> DropletKit::AccountResource

Actions supported:

* `client.account.info()`


## Contributing

1. Fork it ( https://github.com/digitaloceancloud/droplet_kit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request