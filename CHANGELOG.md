## Version 3.16.0

- #266 load balancers: add new field disable_lets_encrypt_dns_records - @dikshant

## Version 3.15.0

- #283 - @sunny-b - K8s: add ha and supported_features fields
- #281 - @bentranter - Add Ruby 3 to CI
- #280 - @andrewsomething - droplet: Add with_droplet_agent attribute.
- #279 - @danaelhe - Doc update- Release.md

## Version 3.14.0

- #277 - @caiofilipini - Add support for DOKS clusters as peers in Firewall rules

## Version 3.13.1

- #274 - @fwitzke - Remove dependency on `try` (Fixes: [#251](https://github.com/digitalocean/droplet_kit/issues/251))

## Version 3.13.0

- #269 database user: Add name to create scope - @jonnyarnold
- #266 load balancers: add new field size - @anitgandhi

## Version 3.12.0

- #264 Add ability to query a domain record resources by name and type - @svyatmuzyka

## Version 3.11.0

- #262 Allow VPCs to be set as default - @caiofilipini

## Version 3.10.0

- #258 Invoice EP retrieve a by UUID - @mberbero
- #257 Invoice List Endpoint support added - @mberbero

## Version 3.9.0

- #255 Balance Endpoint support added - @mberbero

## Version 3.8.1

- #252 Fix response code handler to return created VPC - @viola
- #247 Update spec.email. - @andrewsomething
- #183 Updates `list_resources` action to paginated resource - @bikerdave

### Version 3.8.0

- #245 Allow any Faraday version greater than 0.15 - @bentranter
- #242 Add support for registry/repository.TagCount - @nicktate
- #241 Add DOCR EA routes - @nicktate
- #240 Upgrade minimum Ruby version to 2.5 - @bentranter

### Version 3.7.0

- #237 Add VPC v3 attributes - @viola
- #234 load balancers: add new field enable_backend_keepalive - @anitgandhi

### Version 3.6.0

- #231 Add method to reset database user auth - @zbarahal-do

### Version 3.5.1

- #227 Fix PaginatedResource's "last?" method - @bentranter
- #225 make sure cookie_ttl_seconds always int - @zachgersh
- #224 Remove Sinatra development dependency. - @andrewsomething
- #220 Configure WhiteSource Bolt for GitHub - @whitesource-bolt-for-github[bot]

### Version 3.5.0

- #214 Add dbaas support - @gregmankes

### Version 3.4.1

- #215 Change create_cluster handler to 201 IAW DO::Database docs - @swanny85

### Version 3.4.0
- #212 Fix awkward sentence - @bentranter
- #211 Add partial support for managed databases - @bentranter

### Version 3.3.1
* #209 loadbalancer: default fields to false, not null - @zachgersh

### Version 3.3.0
* #206 Add container registry support - @snormore
* #204 Allowing :filesystem_type on a Volume - @iCreateJB

### Version 3.2.0
* #201 update release instructions - @hilary
* #202 droplet: Expose volume_ids attribute (Fixes: #189). - @andrewsomething
* #199 Drop ActiveSupport as a dependency - @michaelherold

### Version 3.1.0
* #197 Fix Snapshots documentation header - @ruf-io
* #196 add ruby 2.6 to CI - @hilary
* #195 DOKS cluster node pool auto-scaling fields - @snormore
* #194 DOKS cluster auto-upgrade fields - @snormore

### Version 3.0.3
* #190 Kubernetes clusters can not be created with user assigned IDs - @andrewsomething
* #187 Release docs - @leprasmurf

### Version 3.0.2
* noop - yanked 3.0.1

### Version 3.0.1
* #184 Add client override for API URL - @leprasmurf

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
