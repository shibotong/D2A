#!/bin/sh

# Install SwiftLint using Homebrew.
brew install swiftlint

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' >> ../Shared/GraphQL/secrets.json
