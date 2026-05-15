#!/bin/sh

echo 'Creating Tags'

VERSION=v$(cat ../D2A.xcodeproj/project.pbxproj | grep -m3 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ' | tail -n 1)

echo $VERSION


curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GIT_AUTH_TOKEN}" https://api.github.com/repos/${GIT_ACCOUNT}/${CI_PRODUCT}/releases -d "{\"tag_name\": \"${VERSION}\",\"name\": \"${VERSION}\", \"generate_release_notes\": true, \"make_lates\": true}"
