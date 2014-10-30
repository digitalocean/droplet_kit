### Version 1.1.0

* Changing kernels is now `client.droplet_actions.change_kernel(kernel: 'name', droplet_id: 123)` instead of `droplet_actions.kernel()`.
* Include Account resource. `client.account`. This allows you to grab information about the user for the access token provided.

### August 8, 2014 (Initial Release)

* Initial Release