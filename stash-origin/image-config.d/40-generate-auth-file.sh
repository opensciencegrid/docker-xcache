#!/bin/bash -x

# Generate the Authfiles and scitokens.conf file
if supervisord_is_enabled stash-origin; then
    /usr/libexec/xcache/authfile-update stash-origin
fi
if supervisord_is_enabled stash-origin-auth; then
    /usr/libexec/xcache/authfile-update stash-origin-auth
fi


shopt -s nullglob
for f in /run/stash-origin/* /run/stash-origin-auth/*; do
    chown xrootd:xrootd "$f"
done
shopt -u nullglob

# ddavila 20220225: Save the env var ORIGIN_FQDN to be used
# later by 'xrootd' on the 'authfile-update' script.
echo "# This file was generated on startup" > /etc/xrootd-environment

if [[ -n ${ORIGIN_FQDN} ]]; then
        echo "export ORIGIN_FQDN=${ORIGIN_FQDN}" >> /etc/xrootd-environment
fi
chown xrootd:xrootd /etc/xrootd-environment
