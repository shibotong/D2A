#!/bin/sh

set -e

if [ "${CI_WORKFLOW}" != 'Submit to App Store' ]
then
    exit 0
fi

if [[ -n $CI_APP_STORE_SIGNED_APP_PATH ]]
then
    ./create_tag.sh
fi
