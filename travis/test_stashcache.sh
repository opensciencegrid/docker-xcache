#!/bin/bash -xe
# Script for testing StashCache docker images


docker run --rm --publish 8000:8000 \
       --network="host" \
       --env-file=$(pwd)/travis/stashcache-cache-config/cache-env \
       --volume $(pwd)/travis/stashcache-cache-config/10-stash-cache.conf:/etc/supervisord.d/10-stash-cache.conf \
       --volume $(pwd)/travis/stashcache-cache-config/90-docker-ci.cfg:/etc/xrootd/config.d//90-docker-ci.cfg  \
       --name test_cache opensciencegrid/stash-cache:fresh &
docker ps 
sleep 30
docker exec -it test_cache sh -c "ps aux | grep xrootd"


online_md5="$(curl -sL http://localhost:8000/stashcache-travis-ci-test/test_file | md5sum | cut -d ' ' -f 1)"
local_md5="$(md5sum $(pwd)/travis/stashcache-origin-config/test_file)"
if [ "$online_md5" != "$local_md5" ]; then
    echo "MD5sums do not match on stashcache"
    exit 1
fi
