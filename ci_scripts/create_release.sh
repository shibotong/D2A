#!/bin/sh

VERSION=v$(cat ../D2A.xcodeproj/project.pbxproj | grep -m3 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ' | tail -n 1)

swift ./create_release.swift ${GIT_ACCOUNT} ${CI_PRODUCT} ${GIT_AUTH_TOKEN} ${VERSION}
