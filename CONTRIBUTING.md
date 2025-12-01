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

## Pull Request Guidelines

Ensure that each proposed commit is atomic, i.e. it includes only the required
changes to achieve its goal while moving the project to a consistent state. If
the proposed goal requires too much code change to be atomic, consider breaking
it into smaller goals, which are atomic by themselves and are wired up by a
final commit. The title should follow the pattern `<scope>: <description>`,
with `scope` being one of the previously used, if possible. The message should
properly document why the changes should be done in the proposed way, possibly
including context information and motivations, present tradeoffs that were
considered, alternative implementations considered and any other relevant
information, such as co-authors, external references and related commits.

Any information relevant for understanding the proposed changes should be
contained in the respective commit messages, and only highlighted in the PR
description for convenience. The pull request must include a brief description
of the overall goal of the proposed changes, and related PRs or issues when
relevant.

Feel free to add other comments regarding the status of the proposed changes,
e.g. what changes are still missing to promote the PR to non-draft or what
needs further validation.

Add a changelog entry (usually the commit title and the pull request URL) in
[CHANGES.md](CHANGES.md) if the proposed changes are relevant for end-users.
Use sub-items to provide relevant additional information concisely, following
the format of existing entries.

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
