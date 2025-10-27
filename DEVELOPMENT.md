# Development Procedures

## Pre-Commit Hooks

We use the `pre-commit` tool to register pre-commit hooks; these hooks are also
run as part of our CI setup. To use our configured hooks, the following
packages need to be installed manually:

- `pre-commit`
- `shfmt`

And the command below should be run in the repository (the additional flag is
useful if working with older branches which are missing a configuration file):

```
$ pre-commit install --allow-missing-config
```

## Release Procedure

When tagging a new release, which we will call `vX.Y.Z`, a few steps are
necessary.

### Housekeeping

#### Check repository Issues and Pull Requests

Make sure there aren't any pending issues before tagging a new release.

### Run release script

The release script is used to make the necessary changes to enable tagging
version `vX.Y.Z`:

```
$ ./make-release.sh vX.Y.Z
```

The script will create a separate branch, where it will make the necessary
changes and prompt you for any further required information.

#### (Optional) Create Pull Request for these commits

Make sure the description covers all relevant points.

#### Create tag

The tag should be signed and created locally, and point to the release commit
which was merged to the main branch:

```
$ git tag -a -s -m vX.Y.Z vX.Y.Z <release-commit-ref>
```

For this step, it is necessary to [configure Git to sign tags with SSH
keys](https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html).
