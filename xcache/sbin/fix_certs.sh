#!/bin/bash -xe

cp /etc/grid-security/{hostcert.pem,xrd/xrdcert.pem}
cp /etc/grid-security/{hostkey.pem,xrd/xrdkey.pem}
chmod 644  /etc/grid-security/xrd/xrdcert.pem
chmod 600 /etc/grid-security/xrd/xrdkey.pem
chown xrootd:xrootd /etc/grid-security/xrd/xrd*.pem
