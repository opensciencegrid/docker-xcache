#!/bin/bash
if [ -f etc/grid-security/hostcert.pem ]; then
  /usr/local/sbin/fix_certs.sh
fi
