# Release Procedure

When tagging a new release, which we will call `vX.Y.Z`, a few steps are
necessary.

## Housekeeping

### Check repository Issues and Pull Requests

Make sure there aren't any pending issues before tagging a new release.

## Release commit

### Change version in `Dockerfile`

The image version specified in [`Dockerfile`](./Dockerfile) should be `vX.Y.Z`.

### Change version in CHANGES

The "Unreleased" version in [CHANGES](./CHANGES.md) should be changed to
`vX.Y.Z`, and a new "Unreleased" header should be added.

### Add release description to CHANGES

This description should answer the "who needs this update?" question.

### Create release commit

This commit should contain only the above change, and be titled `Release
version vX.Y.Z.`.

### (Optional) Create Pull Request for this commit

Make sure the description covers all relevant points.

### Create tag

The tag should be signed and created locally:

```
$ git tag -a -s vX.Y.Z
```

And its contents should be only the title: `vX.Y.Z`.

For this step, it is necessary to [configure Git to sign tags with SSH
keys](https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html).

## `release` branch

The `release` branch should be updated to point to the new tag.

## `main` branch

A new commit should be created in the `main` branch, updating the version used
in [Dockerfile](./Dockerfile) to `vX.Y.Z-dev` to avoid usage of the `main`
branch in actual deployments.
