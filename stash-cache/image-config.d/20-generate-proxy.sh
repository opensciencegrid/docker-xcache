#!/bin/bash

# Generate the proxy
/usr/local/sbin/fix_certs.sh
/usr/libexec/xcache/renew-proxy
