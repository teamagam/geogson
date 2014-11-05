#!/bin/bash

set -ev

MYDIR="$(dirname "$(readlink -f "$0")")"
PROJECT_VERSION=$(mvn help:evaluate -Dexpression=project.version | grep -Ev '(^\[|Download\w+:)')

export PROJECT_VERSION

if [ "${TRAVIS_PULL_REQUEST}" != 'false' ]; then
    IS_NOT_PULL_REQUEST=false
    PULL_REQUEST=${TRAVIS_PULL_REQUEST}
else
    IS_NOT_PULL_REQUEST=true
fi

if [ "${TRAVIS_BRANCH}" == 'master' ]; then
    IS_MASTER=true
else
    IS_MASTER=false
fi

if [ ${IS_MASTER} == true ] && [ ${IS_NOT_PULL_REQUEST} == true ]; then

    BUILD_NUMBER=${TRAVIS_BUILD_NUMBER}


    PROJECT_VERSION=$(echo ${PROJECT_VERSION} | sed -e "s/-SNAPSHOT/\.$BUILD_NUMBER/")

    mvn versions:set -DnewVersion=${PROJECT_VERSION}
    mvn -N versions:update-child-modules

    export PROJECT_VERSION
fi

mvn clean package



