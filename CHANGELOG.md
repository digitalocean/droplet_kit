### Version 3.0.0
* #180 Add support for VPC - @viola

### Version 2.9.0
* #179 Add support for custom domains in Spaces CDN - @xornivore
* #178 Add enable_proxy_protocol support - @mregmi
* #174 Bump ruby verions in Travis - @tas50
* #173 Only ship the required libraries in the gem artifact - @tas50

### [2.8.0] - 2018-12-11
* #144 Adds the ability to set timeout options for Faraday - @tgturner
* #145 Bump Faraday version to 0.15 - @petems
* #170 Remove test rb file - @scottcrawford03

### Version 2.7.0
* Added KubernetesCluster resource
* Added KubernetesOptions resource
* Added kubernetes cluster and node pool functionality

### Version 2.6.1
* Added custom User-Agent for DropletKit

### Version 2.6.0
* Added ability to manage projects.

### Version 2.5.0
* Added ability to tag images and retrieving new fields for tagged resources.

### Version 2.4.0
* Added CDN resource.

### Version 2.3.0
* Added support for Let's Encrypt certificates.

### Version 2.2.2
* Fix tag / untag resources request body

### Version 2.2.1
* Relaxed faraday version requirement

### Version 2.2.0
* Added Firewall resource.
* Added support for updating TTLs for DomainRecord resource.
* Added support of all Rails 5 releases.
* Added deprecation for Tag resource rename.

### Version 2.1.0
* Added monitoring to the Droplet resource.
* Added LoadBalancer resource.
* Added Certificate resource.
* Added min_disk_size, size_gigabytes and created_at to the Image resource.
* Updated DropletActionResource to use tag_name instead of tag.

### Version 2.0.1
* Droplet create action now accepts `tags` attribute.

### Version 2.0.0
* Several duplicate classes have been deprecated and combined:
 * Replace duplicate Backup model/mapping with Image.
 * Remove duplicate ImageAction(Mapping), use Action.
 * Redefine Snapshot model for new Snapshot object, use Image for Droplet snapshots.
* Added support for Snapshot endpoint with volume snapshots.

### Version 1.2.2

* Add image convert action.
* Loosen dependency on ActiveSupport, update travis.
* Add Image#type property.
* Allow client option with indifferent access.
* Add private filtering to image endpoint.
* Add droplet upgrades resource.

### Version 1.2.1

* Update to action resources to support embedded region breaking changes in API.

### Version 1.2.0

* Add droplet upgrade action.
* Pass disk option through to Droplet resize.
* Add support for region_slug in action objects.
* Test coverage for Ruby 2.2.0.
* Documentation updates.

### Version 1.1.3

* Paginate the resource for image actions to retrieve all of them.
* Fix infinite loop bug on pagination last page.
* Updates to documentation.

### Version 1.1.2

* Add `public_ip` and `private_ip` to easily get the IP address on `DropletKit::Droplet` objects returned.

### Version 1.1.1

* Use size_slug instead of size object in droplet mappings.

### Version 1.1.0

* Changing kernels is now `client.droplet_actions.change_kernel(kernel: 'name', droplet_id: 123)` instead of `droplet_actions.kernel()`.
* Include Account resource. `client.account`. This allows you to grab information about the user for the access token provided.
* Paginate more resources. This includes:
  * Droplet Kernels
  * Actions
  * Snapshots
  * Backups
* Allow creating droplets with User Data and Private Networking
  * See [#8](https://github.com/digitalocean/droplet_kit/pull/8) - Thanks @rbishop !
* Fixed a bug where if the resource was paginated and returning 0 entries, an infinite loop would occur.
  * See [#11](https://github.com/digitalocean/droplet_kit/pull/11) - Thanks @webdestroya !

### August 8, 2014 (Initial Release)

* Initial Release
