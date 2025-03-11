#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <release_version>"
    exit 1
fi

RELEASE_VERSION=$1

# Update CHANGES.md
sed -i "s/## Unreleased/&\n\n## $RELEASE_VERSION\n\n%RELEASE NOTES TEMPLATE - Lines starting with '%' will be ignored.\n%This description should answer the \"who needs this update?\" question.\n/" CHANGES.md
${EDITOR:-vim} +9 CHANGES.md
sed -i '/^%/d' CHANGES.md

# Update version in Dockerfile
sed -i -E "s/v[0-9]+\.[0-9]+\.[0-9]+-dev/$RELEASE_VERSION/" Dockerfile

git switch -c release-$RELEASE_VERSION
git add CHANGES.md Dockerfile
git commit -m "Release version ${RELEASE_VERSION}." CHANGES.md Dockerfile

# Post-release version bump
DEV_VERSION="${RELEASE_VERSION}-dev"

sed -i -E "s/$RELEASE_VERSION/$DEV_VERSION/" Dockerfile

git add Dockerfile
git commit -m "Post-release development version bump." Dockerfile

echo "Check your local modifications before submitting with"
echo "git push origin release-$RELEASE_VERSION"
