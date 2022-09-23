#!/bin/sh

# Install CocoaPods using Homebrew.
brew install cocoapods

# Install dependencies you manage with CocoaPods.
pod install

# Add Secret
echo '
{
    "stratzToken": "$STRATZTOKEN""
}
' >> Shared/GraphQL/secrets.json
