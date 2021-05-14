## Releasing

Once the changes have been merged to main it's time to release a new
version of the gem.

1. Creating a PR with a semantic version
bump to
[version](https://github.com/digitalocean/droplet_kit/blob/main/lib/droplet_kit/version.rb)
and all the changes being released added to the
[CHANGELOG](https://github.com/digitalocean/droplet_kit/blob/main/CHANGELOG.md).
1. After the PR has been merged, create a release
on github for the new version:
    - The tag should be in the format of: vX.Y.Z 
        - You can think of X.Y.Z as such:
            X = breaking
            Y = feature
            Z = bugfix
    - The title should be in the format of: vX.Y.Z (same as tag)
    - The description should include all the changes being released in the format of:
        - #[PR #] - @[contributor] - [description]
1. The release will be pushed to rubygems by a concourse job. Concourse checks the
repo for a new release every 5 minutes, so there's a slight delay.