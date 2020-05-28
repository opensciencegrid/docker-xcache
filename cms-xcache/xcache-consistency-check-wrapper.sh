#!/bin/bash
ENABLE=`awk -F "=" '/^XC_XCACHE_CONSISTENCY_CHECK/ {print $2}' /etc/environment`

if [ "$ENABLE" == "1" ]
then
    echo "Starting XCache consistency check..."
    export PYTHONPATH=/usr/lib/xcache-consistency-check/usr/lib/python2.7/site-packages/:/usr/lib/xcache-consistency-check/usr/lib64/python2.7/site-packages/
    /usr/bin/xcache-consistency-check --config /etc/xrootd/xcache-consistency-check.cfg
else
    echo "XCache consistency check disabled via the environment (XC_XCACHE_CONSISTENCY_CHECK=$ENABLE)..."
fi
