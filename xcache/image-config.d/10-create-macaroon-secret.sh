#!/bin/bash

[[ -e /etc/xrootd/macaroon-secret ]] || /usr/libexec/xrootd/create_macaroon_secret || :
