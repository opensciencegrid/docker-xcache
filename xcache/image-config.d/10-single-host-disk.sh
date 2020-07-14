#!/bin/bash

# If the user is mounting a single disk onto /xcache, create oss.localroot for them
# (image default: /xcache/namespace).
namespace_dir="$XC_ROOTDIR"
mkdir -p $namespace_dir

# Ensure that data and meta disk dirs exist using the prescribed format
# This allows users to easily transition to a multi-disk setup
cache_dir=$(dirname $namespace_dir)

for dirtype in meta data; do
    # Requires $XC_ROOT_DIR to be set in container environment, which
    # is set by default in the atlas-xcache, cms-xcache, stash-cache,
    # and stash-origin images. oss.space directives can look like:
    # oss.space data /xcache/data*
    # oss.space meta /xcache/disk*
    space_dirs=$(cconfig -c "/etc/xrootd/xrootd-$XC_IMAGE_NAME.cfg" 2>&1 \
                     | awk "/^oss.space $dirtype/ {print \$3}")

    # If oss.space dirs from the config don't already exist, create
    # one. We use 'ls -l' here since "$space_dirs" can include
    # wildcards (*).
    # N.B. As long as a single path specified in an oss.space
    # directive exists, XRootD is happy
    if [[ -z $(ls -l "$space_dirs" 2> /dev/null) ]]; then
        default_dir="$cache_dir/$dirtype"1
        mkdir -p "$default_dir"
    fi
done
