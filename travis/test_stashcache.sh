#!/bin/bash -xe
# Script for testing StashCache docker images


docker run --rm --publish 8000:8000 \
       --env-file=$(pwd)/travis/stashcache-cache-config/cache-env \
       --volume $(pwd)/travis/stashcache-cache-config/10-stash-cache.conf:/etc/supervisord.d/10-stash-cache.conf \
       --volume $(pwd)/travis/stashcache-cache-config/90-docker-ci.cfg:/etc/xrootd/config.d//90-docker-ci.cfg  \
       --name test_cache opensciencegrid/stash-cache:fresh &
docker ps 
sleep 30
docker exec -it test_cache sh -c "ps aux | grep xrootd"


