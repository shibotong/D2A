#!/bin/sh

# Create file

touch ../Resources/graphql/secrets.json

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' > ../Resources/graphql/secrets.json

# enable swift macro in xcode cloud
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
