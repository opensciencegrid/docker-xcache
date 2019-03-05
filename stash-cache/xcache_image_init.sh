#!/bin/bash

# Generate the proxy
/usr/local/sbin/fix_certs.sh
su xrootd /usr/libexec/xcache/renew-proxy
