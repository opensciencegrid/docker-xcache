#!/bin/bash -xe

grid_security='/etc/grid-security/'
xrd="$grid_security/xrd/"

tmpcert=`mktemp`
tmpkey=`mktemp`

chmod 644 $tmpcert
chmod 600 $tmpkey
chown xrootd:xrootd $tmpcert $tmpkey

cp $grid_security/hostcert.pem $tmpcert
cp $grid_security/hostkey.pem $tmpkey

mv $tmpcert $xrd/xrdcert.pem
mv $tmpkey $xrd/xrdkey.pem
