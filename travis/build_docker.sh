#!/bin/bash -xe
# Script for building and pushing XCache docker images

timestamp="$1"

for repo in $DOCKER_REPOS; do
    docker build \
           -t $DOCKER_ORG/$repo:fresh \
           -t $DOCKER_ORG/$repo:$timestamp \
           $repo
done

