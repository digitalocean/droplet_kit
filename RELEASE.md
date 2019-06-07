## Releasing

Once the changes have been merged to master it's time to release a new version of the gem.  Start by creating a PR with a semantic version bump to [version](https://github.com/digitalocean/droplet_kit/blob/master/lib/droplet_kit/version.rb) and all the changes being released to the [CHANGELOG](https://github.com/digitalocean/droplet_kit/blob/master/CHANGELOG.md).

After that has been merged the rest of the deploy can be completed with rake.  See the rake tasks for more information:

```
$ git checkout master
$ git pull origin master
$ bundle exec rake --tasks
rake build            # Build droplet_kit-1.2.3.gem into the pkg directory
rake clean            # Remove any temporary products
rake clobber          # Remove any generated files
rake install          # Build and install droplet_kit-1.2.3.gem into system gems
rake install:local    # Build and install droplet_kit-1.2.3.gem into system gems without network access
rake release[remote]  # Create tag v1.2.3 and build and push droplet_kit-1.2.3.gem to rubygems.org
```

Assuming you have the correct permissions (See DO's lastpass account for "rubygems" credentials) a `bundle exec rake release` will perform the necessary tasks to release your new version:

* Create a release tag in the current repo `git tag vX.Y.Z`
* Build the gem `bundle exec rake build`
* Push repo changes back to github
* Push the gem to rubygems.org `bundle exec gem push pkg/droplet_kit-1.2.3.gem`

## Gotchas

Utilizing rake for performing the release steps has the advantage of rolling back to the pre-run state in the event of a task failure.  If you decide to run through the steps manually `bundle exec rake release` will likely fail along the way due to conflicts.

`gem yank droplet_kit -v 1.2.3` will revoke a gem at a specified version.  This version can *not* be used [after it has been yanked](https://help.rubygems.org/kb/gemcutter/removing-a-published-rubygem#why-can-39-t-i-repush-a-gem-version-).
