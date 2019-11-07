#!/bin/bash -xe
# Script for testing StashCache docker images

docker run --rm --publish 1094:1094 \
       --env-file=$(pwd)/stashche-origin-config/origin-env \
       --volume $(pwd)/stashche-origin-config/empty_stash-origin-auth.conf:/etc/supervisord.d/stash-origin-auth.conf \
       --volume $(pwd)/stashche-origin-config/10-origin-authfile.cfg:/etc/xrootd/config.d/10-origin-authfile.cfg \
       --volume  $(pwd)/stashche-origin-config/authfile:/etc/xrootd/public-origin-authfile \
       --name test_origin opensciencegrid/stash-origin:fresh &
docker ps 
docker exec -it test_origin ps aux | grep xrootd


