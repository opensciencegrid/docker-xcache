#!/bin/bash                                                                                                                                                                   
CERT_DIR=/etc/grid-security/
mkdir -p $CERT_DIR/xrd
cp -f $CERT_DIR/hostcert.pem /etc/grid-security/xrd/xrdcert.pem
cp -f $CERT_DIR/xrdkey.pem /etc/grid-security/xrd/xrdkey.pem
chmod 644  /etc/grid-security/xrd/xrdcert.pem
chmod 600 /etc/grid-security/xrd/xrdkey.pem
chown xrootd:xrootd /etc/grid-security/xrd/xrd*.pem
