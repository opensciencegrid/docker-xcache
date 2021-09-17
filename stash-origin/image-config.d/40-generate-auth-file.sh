#!/bin/bash

# Generate the Auth File
/usr/libexec/xcache/authfile-update --origin
chown xrootd:xrootd /run/stash-cache-auth/*
chown xrootd:xrootd /run/stash-cache/*
