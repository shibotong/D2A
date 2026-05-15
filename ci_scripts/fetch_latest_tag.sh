#!/bin/bash

# Fetch the latest tag by creation time, excluding placeholder tags
# Usage: ./fetch_latest_tag.sh

# Option 1: Get latest tag excluding ${VERSION}
git for-each-ref --sort=-creatordate --format='%(refname:short)' refs/tags \
  | grep -v '^\${VERSION}$' \
  | head -n 1

# Option 2: If you want to include ${VERSION} if it's truly the latest:
# git describe --tags --abbrev=0

# Option 3: For SemVer sorting (if tags follow semantic versioning):
# git tag --sort=-version:refname | head -n1
