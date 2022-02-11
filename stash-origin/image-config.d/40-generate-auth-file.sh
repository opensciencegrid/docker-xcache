#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --origin
shopt -s nullglob
for f in /run/stash-origin/* /run/stash-origin-auth/*; do
    chown xrootd:xrootd "$f"
done
shopt -u nullglob
