#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --cache
chown xrootd:xrootd /run/stash-cache-auth/*
chown xrootd:xrootd /run/stash-cache/*

# ddavila 20211020: Save the env vars CACHE_FQDN or ORIGIN_FQDN to be used
# later by 'xrootd' on the 'authfile-update' script.
echo "# This file was genrated on startup" > /etc/xrootd-environment

if [[ -n ${CACHE_FQDN} ]]; then
        echo "export CACHE_FQDN=${CACHE_FQDN}" >> /etc/xrootd-environment
fi

if [[ -n ${ORIGIN_FQDN} ]]; then
        echo "export ORIGIN_FQDN=${ORIGIN_FQDN}" >> /etc/xrootd-environment
fi
chown xrootd:xrootd /etc/xrootd-environment
