#!/bin/sh

echo 'Creating Tags'

VERSION=$(cat ../D2A.xcodeproj/project.pbxproj | grep -m3 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ' | tail -n 1)

echo $VERSION

git tag v${VERSION}

git push --tags https://${GIT_ACCOUNT}:${GIT_AUTH_TOKEN}@github.com/${GIT_ACCOUNT}/${CI_PRODUCT}.git
