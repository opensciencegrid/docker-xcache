#!/bin/bash -xe
# Script for building and pushing XCache docker images

IMAGE_NAME="$1"

docker build -t opensciencegrid/$IMAGE_NAME:development $IMAGE_NAME
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push opensciencegrid/$IMAGE_NAME:development
