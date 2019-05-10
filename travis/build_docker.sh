#!/bin/bash -xe
# Script for building and pushing XCache docker images

org='opensciencegrid'
timestamp=`date +%Y%m%d-%H%M`
docker_repos='xcache stash-cache stash-origin atlas-xcache'

for repo in $docker_repos; do
    docker build \
           -t $org/$repo:fresh \
           -t $org/$repo:$timestamp \
           $repo
done

docker run --name test_stash_cache stash-cache:fresh &
docker ps
docker exec -it test_stash_cache yum install -y osg-test
docker exec -it test_stash_cache osg-test -mvad

if [[ "${TRAVIS_PULL_REQUEST}" != "false" ]]; then
    echo "DockerHub deployment not performed for pull requests"
    exit 0
fi

# Credentials for docker push
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for repo in $docker_repos; do
    for tag in $timestamp fresh; do
        docker push $org/$repo:$tag
    done
done
