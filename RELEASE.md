# Releasing

> **Note:** DropletKit is deprecated (see [README](README.md)). **No new gem releases are planned.** This document is kept for maintainers handling historical releases or a final deprecation notice release.

## Historical process

Once changes were merged to `main`, a new gem version was released as follows:

1. Create a PR with a semantic version bump to
   [version](https://github.com/digitalocean/droplet_kit/blob/main/lib/droplet_kit/version.rb)
   and all changes being released added to the
   [CHANGELOG](https://github.com/digitalocean/droplet_kit/blob/main/CHANGELOG.md).
2. After the PR was merged, create a release on GitHub for the new version:
   - Tag format: `vX.Y.Z`
   - Version semantics: `X` = breaking, `Y` = feature, `Z` = bugfix
   - Release description: `#[PR #] - @[contributor] - [description]`
3. When the tag was created, a GitHub Actions workflow published the release to RubyGems.

## Deprecation

If a final gem release is published to surface the `post_install_message` in `droplet_kit.gemspec`, follow the steps above with a patch version bump and a CHANGELOG entry documenting the deprecation notice.
