#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --origin
shopt -s nullglob

# ddavila 20220225: Save the env var ORIGIN_FQDN to be used
# later by 'xrootd' on the 'authfile-update' script.
echo "# This file was generated on startup" > /etc/xrootd-environment

if [[ -n ${ORIGIN_FQDN} ]]; then
        echo "export ORIGIN_FQDN=${ORIGIN_FQDN}" >> /etc/xrootd-environment
fi
