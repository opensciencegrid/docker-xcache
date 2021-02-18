#!/bin/bash -x
# Script for testing StashCache docker images

TEST_IMAGE="$1"

docker run --rm \
       --network="host" \
       --volume $(pwd)/tests/stashcache-cache-config/90-docker-ci.cfg:/etc/xrootd/config.d//90-docker-ci.cfg  \
       --volume $(pwd)/tests/stashcache-cache-config/Authfile:/run/stash-cache/Authfile \
       --name test_cache "$TEST_IMAGE" &
docker ps 

ATTEMPTS=60
RC=1
while [[ $ATTEMPTS -gt 0 ]] && [[ $RC -ne 0 ]]; do
    sleep 10
    curl -v -sL http://localhost:8000/test_file
    RC=$?
    (( ATTEMPTS-- ))
done

online_md5="$(curl -sL http://localhost:8000/test_file | md5sum | cut -d ' ' -f 1)"
local_md5="$(md5sum $(pwd)/tests/stashcache-origin-config/test_file | cut -d ' ' -f 1)"
if [ "$online_md5" != "$local_md5" ]; then
    echo "MD5sums do not match on stashcache"
    docker exec test_cache cat /var/log/xrootd/stash-cache/xrootd.log
    docker stop test_cache
    exit 1
fi
