#!/bin/bash

if [[ $XC_FIX_DIR_OWNERS != 'yes' ]]; then
    return
fi

namespace_dir=$(cconfig -c "/etc/xrootd/xrootd-$XC_IMAGE_NAME.cfg" 2>&1 \
                     | awk "/^oss.localroot/ {print \$2}")
space_dirs=$(cconfig -c "/etc/xrootd/xrootd-$XC_IMAGE_NAME.cfg" 2>&1 \
                     | awk "/^oss.space/ {print \$3}")

for oss_dir in $namespace_dir $space_dirs; do
    chown -R xrootd:xrootd $oss_dir
done
