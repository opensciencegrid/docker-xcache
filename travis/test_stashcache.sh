#!/bin/bash -xe
# Script for testing StashCache docker images


docker run --rm --publish 1094:1094 \
       --env-file=$(pwd)/travis/stashcache-origin-config/origin-env \
       --volume $(pwd)/travis/stashcache-origin-config/empty_stash-origin-auth.conf:/etc/supervisord.d/stash-origin-auth.conf \
       --volume $(pwd)/travis/stashcache-origin-config/10-origin-authfile.cfg:/etc/xrootd/config.d/10-origin-authfile.cfg \
       --volume $(pwd)/travis/stashcache-origin-config/authfile:/etc/xrootd/public-origin-authfile \
       --name test_origin opensciencegrid/stash-origin:fresh &
docker ps 
sleep 10
docker exec -it test_origin ps aux


