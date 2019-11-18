#!/bin/bash -xe
# Script for building and pushing XCache docker images

org='opensciencegrid'
timestamp=`date +%Y%m%d-%H%M`
docker_repos='xcache stash-cache stash-origin atlas-xcache cms-xcache'

for repo in $docker_repos; do
    docker build \
           -t $org/$repo:fresh \
           -t $org/$repo:$timestamp \
           $repo
done

