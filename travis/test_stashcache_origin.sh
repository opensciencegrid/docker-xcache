#!/bin/bash -xe
# Script for testing StashCache docker images


docker run --rm \
       --network="host" \
       --env-file=$(pwd)/travis/stashcache-origin-config/origin-env \
       --volume $(pwd)/travis/stashcache-origin-config/empty_stash-origin-auth.conf:/etc/supervisord.d/stash-origin-auth.conf \
       --volume $(pwd)/travis/stashcache-origin-config/10-origin-authfile.cfg:/etc/xrootd/config.d/10-origin-authfile.cfg \
       --volume $(pwd)/travis/stashcache-origin-config/authfile:/etc/xrootd/public-origin-authfile \
       --volume $(pwd)/travis/stashcache-origin-config/test_file:/tmp/stashcache-travis-ci-test/test_file \
       --name test_origin opensciencegrid/stash-origin:fresh &
docker ps 
sleep 20

online_md5="$(curl -sL http://localhost:1094/stashcache-travis-ci-test/test_file | md5sum | cut -d ' ' -f 1)"
local_md5="$(md5sum $(pwd)/travis/stashcache-origin-config/test_file | cut -d ' ' -f 1)"
if [ "$online_md5" != "$local_md5" ]; then
    echo "MD5sums do not match on origin"
    docker stop test_origin
    exit 1
fi
