#!/bin/bash -xe
# Script for pushing XCache docker images

if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    echo "DockerHub deployment not performed for pull requests"
    exit 0
fi

# Credentials for docker push                                                                                                                                                                                       
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for repo in $DOCKER_REPOS; do
    for tag in $timestamp fresh; do
        docker push $DOCKER_ORG/$repo:$tag
    done
done
