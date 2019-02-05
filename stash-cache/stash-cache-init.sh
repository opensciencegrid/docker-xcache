#!/bin/bash

instance="$1"

# Generate the proxy
/usr/local/sbin/fix_certs.sh
su xrootd /usr/libexec/xcache/renew-proxy

# Start the cache
su xrootd -c "xrootd -c /etc/xrootd/xrootd-$instance.cfg -k fifo -n $instance -k 10 -s /var/run/xrootd/xrootd-$instance.pid -l /var/log/xrootd/xrootd.log"
