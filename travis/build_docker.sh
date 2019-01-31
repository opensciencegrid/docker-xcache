#!/bin/bash -xe
# Script for building and pushing XCache docker images

org='opensciencegrid'
timestamp=`date +%Y%m%d-%H%M`

for repo in xcache stash-cache atlas-xcache; do
    docker build \
           -t $org/$repo:development \
           -t $org/$repo:$timestamp \
           $repo
done

# Credentials for docker push
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for repo in xcache stash-cache atlas-xcache; do
    for tag in development $timestamp; do
        docker push $org/$repo:$tag
    done
done
