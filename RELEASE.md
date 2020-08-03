## Releasing

Once the changes have been merged to master it's time to release a new
version of the gem.

1. Creating a PR with a semantic version
bump to
[version](https://github.com/digitalocean/droplet_kit/blob/master/lib/droplet_kit/version.rb)
and all the changes being released added to the
[CHANGELOG](https://github.com/digitalocean/droplet_kit/blob/master/CHANGELOG.md).
1. After the PR has been merged, create a release
on github for the new version.
1. The release will be pushed to rubygems by a concourse job. Concourse checks the
repo for a new release every 5 minutes, so there's a slight delay.

