#!/bin/bash

# If the user is not using the prescribed location, don't separate out
# the namespace, metadata, or data dirs since that may clear the cache
if [[ "$XC_ROOTDIR" != /xcache/namespace ]]; then
    return
fi

# If the user is mounting a single disk onto /xcache, create oss.localroot for them
# (image default: /xcache/namespace).
namespace_dir="$XC_ROOTDIR"
mkdir -p "$namespace_dir"

# Only set oss.space directives for caches using prescribed locations
if [[ "$XC_IMAGE_NAME" != stash-origin ]]; then
        cat <<EOF >> /etc/xrootd/config.d/50-docker-spaces.cfg
pfc.spaces data meta
oss.space meta /xcache/meta*
oss.space data /xcache/data*
EOF
fi


# Ensure that data and meta disk dirs exist using the prescribed format
# This allows users to easily transition to a multi-disk setup
for dirtype in meta data; do
    # Requires $XC_ROOTDIR to be set in container environment, which
    # is set by default in the atlas-xcache, cms-xcache, stash-cache,
    # and stash-origin images. oss.space directives can look like:
    # oss.space data /xcache/data*
    # oss.space meta /xcache/disk*
    space_dirs=$(cconfig -c "/etc/xrootd/xrootd-$XC_IMAGE_NAME.cfg" 2>&1 \
                     | awk "/^oss.space $dirtype/ {print \$3}")

    # If oss.space dirs from the config don't already exist, create
    # one. We use 'ls -1' here since "$space_dirs" can include
    # wildcards (*).
    # N.B. As long as a single path specified in an oss.space
    # directive exists, XRootD is happy
    if [[ -z $(ls -1 $space_dirs 2> /dev/null) ]]; then
        default_dir="/xcache/$dirtype"1
        mkdir -p "$default_dir"
    fi
done
