#!/bin/bash
if [ -f etc/grid-security/hostcert.pem ]; then
  cp /etc/grid-security/hostcert.pem /etc/grid-security/xrd/xrdcert.pem &&  chown xrootd:xrootd /etc/grid-security/xrd/xrdcert.pem
  cp /etc/grid-security/hostkey.pem  /etc/grid-security/xrd/xrdkey.pem && chmog go-rwx  /etc/grid-security/xrd/xrdkey.pem && chown xrootd:xrootd  /etc/grid-security/xrd/xrdkey.pem
fi
