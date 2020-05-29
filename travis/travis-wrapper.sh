#!/bin/bash -xe
# Wrapper script for building and testing XCache container images

timestamp=`date +%Y%m%d-%H%M`

./travis/build_docker.sh $timestamp
./travis/test_stashcache_origin.sh
./travis/test_stashcache.sh

if [[ $TRAVIS_REPO_SLUG == opensciencegrid/* ]]; then
    ./travis/push_docker.sh $timestamp
else
    echo "*** Not pushing: repo not owned by opensciencegrid ***" >&2
fi
