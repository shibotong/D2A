#!/bin/sh

echo 'Creating Tags...'
VERSION=v$(cat ../D2A.xcodeproj/project.pbxproj | grep -m3 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ' | tail -n 1)

echo 'Project version:'
echo $VERSION

LAST_VERSION=$(./fetch_latest_tag.sh)

echo 'Last version:'
echo $LAST_VERSION

# Generate release notes and get the body
RELEASE_NOTES=$(curl -s -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GIT_AUTH_TOKEN}" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/${GIT_ACCOUNT}/${CI_PRODUCT}/releases/generate-notes \
  -d "{\"tag_name\": \"${VERSION}\",\"target_commitish\": \"main\", \"previous_tag_name\": \"${LAST_VERSION}\"}" | jq -r '.body')
  
echo 'Release Notes:'
echo $RELEASE_NOTES

## Create release with generated notes
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GIT_AUTH_TOKEN}" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/${GIT_ACCOUNT}/${CI_PRODUCT}/releases \
  -d "{\"tag_name\": \"${VERSION}\",\"name\": \"${VERSION}\", \"body\": \"$RELEASE_NOTES\", \"make_latest\": true}"
