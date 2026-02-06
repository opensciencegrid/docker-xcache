#!/bin/bash

if [ -f  /etc/grid-security/fetch_scitoken_secret ]; then
  USER=`cat /etc/grid-security/fetch_scitoken_secret |  awk -F ":" '{print $1}'`
  PASS=`cat /etc/grid-security/fetch_scitoken_secret |  awk -F ":" '{print $2}'`

  if [[ -z "$USER" || -z "$PASS" ]]; then
    echo "Wrong format in secret file"
    exit 1
  fi

  curl -s --user $USER:$PASS -d grant_type=client_credentials -d scope="storage.read:/" https://cms-auth.cern.ch/token \
    | python3 -c 'import sys,json; print(json.loads(sys.stdin.read())["access_token"])' > /tmp/jwt_xrdcache

  if [ $? -ne 0 ]; then
    echo "Failed to retrieve token"
    exit 2
  fi

  chown xrootd: /tmp/jwt_xrdcache
  chmod 600 /tmp/jwt_xrdcache

else
  echo "Secret file not found"
fi
