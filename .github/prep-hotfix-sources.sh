#!/bin/bash -x

HOTFIX_TAG=$1
REPO_PATH=$2
SPEC_PATH=$3

# Create OSG build dirs
build_dir=$(pwd)/_build_dir
for dirname in osg upstream; do
    mkdir -p $build_dir/$dirname
done

version=$(echo "$HOTFIX_TAG" | sed "s/v\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/")
# Remove illegal dashes in release string
release=$(tr '-' '.' <<< 1.${HOTFIX_TAG#*-})
sed "s/__VERSION__/$version/" "$SPEC_PATH" | \
    sed "s/__RELEASE__/$release/" > \
        $build_dir/osg/xrootd.spec

cd $REPO_PATH
git checkout "$HOTFIX_TAG"
tarball_path=$build_dir/xrootd.tar.gz
git archive --prefix=xrootd/ --format=tar.gz "$HOTFIX_TAG" > $tarball_path

# absolute path here reflects the location of the tarball when mounted
# in the osg-build container
echo "/u/_build_dir/xrootd.tar.gz sha1sum=$(sha1sum $tarball_path | cut -d ' ' -f 1)" > \
     $build_dir/upstream/developer.tarball.source

# Fix ownership so that osg-build docker container can write to it
# Default GHA user is unprivileged so we need sudo
sudo chown -R 1000:1000 $build_dir
