#!/bin/bash

namespace_dir="$XC_ROOTDIR"
disk_dir=$(dirname $namespace_dir)/disks

host_mounted_disks=$(ls $disk_dir)

if [[ -z $host_mounted_disks ]]; then
    # user has not mounted a separate data disks
    echo "oss.space data $namespace_dir" > /etc/xrootd/config.d/40-data-disks.cfg
else
    for disk in $host_mounted_disks; do
        echo "oss.space data $disk_dir/$disk" >> /etc/xrootd/config.d/40-data-disks.cfg
    done
fi


if [ -n "$DISABLE_OSG_MONITORING" ]; then
    echo -e "set DisableOsgMonitoring = $DISABLE_OSG_MONITORING\n" >> /etc/xrootd/config.d/10-docker-env-var.cfg
fi


