#!/bin/bash

# If the user is mounting a single disk onto /xcache, create oss.localroot for them
# (image default: /xcache/namespace).
# We don't need to do this for oss.space directives since XRootD will automatically
# create the meta and data dirs automatically
namespace_dir="$XC_ROOTDIR"
mkdir -p $namespace_dir
chown xrootd:xrootd $namespace_dir

# Use /xcache as the data store if the user has not mounted separate data disks
# as prescribed (e.g. /xcache/disk1, /xcache/disk2/.../xcache/diskN)
cache_dir=$(dirname $namespace_dir)
if [[ -z $(find $cache_dir -type d  -name 'disk[0-9]*') ]]; then
    echo "oss.space data $cache_dir" > /etc/xrootd/config.d/40-data-disks.cfg
fi

if [ -n "$DISABLE_OSG_MONITORING" ]; then
    echo -e "set DisableOsgMonitoring = $DISABLE_OSG_MONITORING\n" >> /etc/xrootd/config.d/10-docker-env-var.cfg
fi


