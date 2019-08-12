#!/bin/bash
/usr/local/sbin/fix_certs.sh
su xrootd -c '/usr/libexec/xcache/renew-proxy --voms cms'
