#!/bin/bash

# If the user is mounting a single disk onto /xcache, create oss.localroot for them
# (image default: /xcache/namespace).
# We don't need to do this for oss.space directives since XRootD will automatically
# create the meta and data dirs automatically
namespace_dir="$XC_ROOTDIR"
mkdir -p $namespace_dir
chown xrootd:xrootd $namespace_dir

# Ensure that a data disk dir exists using the prescribed format
# This allows users to easily transition to a multi-disk setup
cache_dir=$(dirname $namespace_dir)
if [[ -z $(find $cache_dir -type d  -name 'disk[0-9]*') ]]; then
    data_dir=$cache_dir/disk1
    mkdir -p $data_dir
    chown -R xrootd:xrootd $data_dir
fi
