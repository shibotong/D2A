#!/bin/sh

# Install CocoaPods using Homebrew.
brew install cocoapods

# Install dependencies you manage with CocoaPods.
pod install

echo 'This is token'
echo $STRATZTOKEN
echo $PWD
# Add Secret
echo '
{
    "stratzToken": "${STRATZTOKEN}"
}
' >> Shared/GraphQL/secrets.json
