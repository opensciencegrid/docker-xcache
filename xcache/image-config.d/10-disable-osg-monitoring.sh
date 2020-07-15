#!/bin/bash

if [ -n "$DISABLE_OSG_MONITORING" ]; then
    echo -e "set DisableOsgMonitoring = $DISABLE_OSG_MONITORING\n" >> /etc/xrootd/config.d/10-docker-env-var.cfg
fi
