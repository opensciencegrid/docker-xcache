#!/bin/bash
ENABLE=`awk -F "=" '/^XC_XCACHE_CONSISTENCY_CHECK/ {print $2}' /etc/environment`
echo "ENABLE: "$ENABLE

if [ "$ENABLE" == "1" ]
then
    echo "Starting"
    export PYTHONPATH=/usr/lib/xcache-consistency-check/usr/lib/python2.7/site-packages/:/usr/lib/xcache-consistency-check/usr/lib64/python2.7/site-packages/
    /usr/bin/xcache-consistency-check --config /etc/xrootd/xcache-consistency-check.cfg
fi
