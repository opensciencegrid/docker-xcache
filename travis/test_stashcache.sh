#!/bin/bash -xe
# Script for testing StashCache docker images


docker run --rm \
       --network="host" \
       --env-file=$(pwd)/travis/stashcache-cache-config/cache-env \
       --volume $(pwd)/travis/stashcache-cache-config/90-docker-ci.cfg:/etc/xrootd/config.d//90-docker-ci.cfg  \
       --volume $(pwd)/travis/stashcache-cache-config/Authfile:/run/stash-cache/Authfile \
       --name test_cache opensciencegrid/stash-cache:fresh &
docker ps 
sleep 25
curl -v -sL http://localhost:8000/stashcache-travis-ci-test/test_file

online_md5="$(curl -sL http://localhost:8000/stashcache-travis-ci-test/test_file | md5sum | cut -d ' ' -f 1)"
local_md5="$(md5sum $(pwd)/travis/stashcache-origin-config/test_file | cut -d ' ' -f 1)"
if [ "$online_md5" != "$local_md5" ]; then
    echo "MD5sums do not match on stashcache"
    docker stop test_cache
    exit 1
fi
