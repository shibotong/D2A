#!/bin/sh

# Install SwiftLint using Homebrew.
brew install swiftlint

# Add Secret
echo '{ "stratzToken": "'"$STRATZTOKEN"'" }' >> ../Shared/GraphQL/secrets.json
rm ../D2AUITests/TestCaseString.swift

echo 'struct TestCaseString {' >> ../D2AUITests/TestCaseString.swift
echo '    let userid: String = "153041957"' >> ../D2AUITests/TestCaseString.swift
echo '    let username: String = "Mr.BOBOBO"'  >> ../D2AUITests/TestCaseString.swift
echo '}' >> ../D2AUITests/TestCaseString.swift
