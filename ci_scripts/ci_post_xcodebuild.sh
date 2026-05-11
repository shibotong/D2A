#!/bin/sh

set -e

if [ $CI_WORKFLOW != 'Create Tag' ]
then
exit 1
fi

if [[ -n $CI_APP_STORE_SIGNED_APP_PATH ]];
then
    echo $CI_APP_STORE_SIGNED_APP_PATH
    ./create_tag.sh
fi
