# DropletKit

DropletKit is the official [DigitalOcean V2 API](https://developers.digitalocean.com/v2/) client. It supports everything the API can do with a simple interface written in Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'droplet_kit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install droplet_kit

## Usage

You'll need to generate an access token in Digital Oceans control panel at https://cloud.digitalocean.com/settings/applications

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
# => [ DropletKit::Dropet(id: 123, name: 'something.com', ...), DropletKit::Dropet(id: 1066, name: 'bunk.com', ...) ]
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


## Contributing

1. Fork it ( https://github.com/digitaloceancloud/droplet_kit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
