#!/bin/bash                                                                                                                                                                   
chmod 644  /etc/grid-security/xrd/xrdcert.pem
chmod 600 /etc/grid-security/xrd/xrdkey.pem
chown xrootd:xrootd /etc/grid-security/xrd/xrd*.pem
