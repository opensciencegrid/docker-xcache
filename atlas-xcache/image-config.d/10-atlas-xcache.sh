#!/bin/bash

/usr/local/sbin/fix_certs.sh

su xrootd /usr/libexec/xcache/renew-proxy --voms atlas

