#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --origin
shopt -s nullglob
for f in /run/stash-origin/* /run/stash-origin-auth/*; do
    chown xrootd:xrootd "$f"
done
shopt -u nullglob

# ddavila 20221020: Save the env var ORIGIN_FQDN to be used
# later by 'xrootd' on the 'authfile-update' script.
echo "# This file was genrated on startup" > /etc/xrootd-environment

if [[ -n ${ORIGIN_FQDN} ]]; then
        echo "export ORIGIN_FQDN=${ORIGIN_FQDN}" >> /etc/xrootd-environment
fi
chown xrootd:xrootd /etc/xrootd-environment
