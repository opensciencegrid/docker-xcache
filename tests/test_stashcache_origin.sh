#!/bin/bash -x
# Script for testing StashCache docker images

TEST_IMAGE="$1"

docker run --rm \
       --network="host" \
       --volume $(pwd)/tests/stashcache-origin-config/empty_stash-origin-auth.conf:/etc/supervisord.d/stash-origin-auth.conf \
       --volume $(pwd)/tests/stashcache-origin-config/10-origin-authfile.cfg:/etc/xrootd/config.d/10-origin-authfile.cfg \
       --volume $(pwd)/tests/stashcache-origin-config/authfile:/etc/xrootd/public-origin-authfile \
       --volume $(pwd)/tests/stashcache-origin-config/test_file:/xcache/namespace/test_file \
       --name test_origin "$TEST_IMAGE" &
docker ps 
sleep 20

online_md5="$(curl -sL http://localhost:1094/test_file | md5sum | cut -d ' ' -f 1)"
local_md5="$(md5sum $(pwd)/tests/stashcache-origin-config/test_file | cut -d ' ' -f 1)"
if [ "$online_md5" != "$local_md5" ]; then
    echo "MD5sums do not match on origin"
    docker exec test_origin cat /var/log/xrootd/stash-origin/xrootd.log
    docker stop test_origin
    exit 1
fi
