#!/bin/bash

# Generate the proxy for the authenticated cache
/usr/local/sbin/fix_certs.sh
su xrootd /usr/libexec/xcache/renew-proxy

# Start the authenticated cache
su xrootd xrootd -c /etc/xrootd/xrootd-stash-cache-auth.cfg -k fifo -n stash-cache-auth -k 10 \
   -s /var/run/xrootd/xrootd-stash-cache-auth.pid -l /var/log/xrootd/xrootd.log
