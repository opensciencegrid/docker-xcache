#!/bin/bash                                                                                                                                                                   
XRD_CERT_DIR=/etc/grid-security/xrd
cp -f $XRD_CERT_DIR/xrdcert.pem /etc/grid-security/hostcert.pem
cp -f $XRD_CERT_DIR/xrdkey.pem /etc/grid-security/hostkey.pem
chmod 644  /etc/grid-security/hostcert.pem
chmod 600 /etc/grid-security/hostkey.pem
chown condor:condor /etc/grid-security/host*.pem
