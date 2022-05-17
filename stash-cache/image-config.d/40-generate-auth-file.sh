#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --cache
shopt -s nullglob

# ddavila 20211020: Save the env vars CACHE_FQDN to be used
# later by 'xrootd' on the 'authfile-update' script.
echo "# This file was generated on startup" > /etc/xrootd-environment

if [[ -n ${CACHE_FQDN} ]]; then
        echo "export CACHE_FQDN=${CACHE_FQDN}" >> /etc/xrootd-environment
fi

