#!/bin/bash -xe
# Script for building and pushing XCache docker images

org='opensciencegrid'
timestamp=`date +%Y%m%d-%H%M`
docker_repos='xcache stash-cache stash-origin atlas-xcache'

for repo in $docker_repos; do
    docker build \
           -t $org/$repo:development \
           -t $org/$repo:$timestamp \
           $repo
done

if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    echo "DockerHub deployment not performed for pull requests"
    exit 0
fi

# Credentials for docker push
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for repo in $docker_repos; do
    for tag in $timestamp development; do
        docker push $org/$repo:$tag
    done
done
