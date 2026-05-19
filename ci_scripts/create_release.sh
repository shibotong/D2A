#!/bin/sh

VERSION=v$(cat ../D2A.xcodeproj/project.pbxproj | grep -m3 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ' | tail -n 1)

echo "this is user name"
echo $GIT_USER_NAME

echo "this is ci product"
echo $CI_PRODUCT

swift ./create_release.swift $GIT_USER_NAME ${CI_PRODUCT} $GIT_AUTH_TOKEN ${VERSION}
