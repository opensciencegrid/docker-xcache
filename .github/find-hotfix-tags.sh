#!/bin/bash

tag_regex='v[0-9]+\.[0-9]+\.[0-9]+-hotfix-[A-Za-z]+'
git tag -l | egrep $tag_regex > git_tags

token=$(curl -s \
             -H "Content-Type: application/json" \
             -X POST \
             -d '{"username": "'${DOCKER_USERNAME}'", "password": "'${DOCKER_PASSWORD}'"}' \
             https://hub.docker.com/v2/users/login/ | jq -r .token)

curl -s \
     -H "Authorization: JWT ${token}" \
     https://hub.docker.com/v2/repositories/brianhlin/stash-cache/tags/?page_size=100 | \
    jq -r '.results|.[]|.name' | \
    egrep $tag_regex > dockerhub_tags

# cowardly only build one hotfix tag at a time
build_candidate=$(comm -23 git_tags dockerhub_tags | head -n 1)

echo "::set-output name=tag::$build_candidate"
