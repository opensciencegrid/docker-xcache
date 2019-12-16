#!/bin/bash -xe
# Wrapper script for building and testing XCache container images

timestamp=`date +%Y%m%d-%H%M`

cd travis

./build_docker.sh $timestamp
./test_stashcache_origin.sh
./test_stashcache.sh
./push_docker.sh $timestamp
