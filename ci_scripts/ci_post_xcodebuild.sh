#!/bin/sh

set -e

echo "Running workflow: $CI_WORKFLOW"
echo "Running action: $CI_XCODEBUILD_ACTION"

if [ "$CI_WORKFLOW" != 'Submit to App Store' ]
then
    exit 0
fi

if [ "$CI_XCODEBUILD_ACTION" != 'archive' ]
then
    exit 0
fi

if [[ -d $CI_APP_STORE_SIGNED_APP_PATH ]]
then
    ./create_release.sh
fi
