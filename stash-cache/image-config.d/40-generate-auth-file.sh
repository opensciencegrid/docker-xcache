#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --cache
chown xrootd:xrootd /run/stash-cache-auth/Authfile
chown xrootd:xrootd /run/stash-cache/Authfile

