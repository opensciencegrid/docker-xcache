#!/bin/sh

X509_USER_PROXY=/etc/proxy/x509up
X509_CERT_DIR=/etc/grid-security/certificates/

size=`df -l | grep xcache/data | awk '{sum+=$2;} END{print sum;}'`

# sleep until x509 things set up.
while [ ! -f $X509_USER_PROXY ]
do
  sleep 10
  echo "waiting for x509 proxy."
done

ls -lh $X509_USER_PROXY


rucio whoami

while true; do 
  date

  # echo 'checking xcache'
  # change to actual server address.
  RESULT=$(xrdfs $ADDRESS query config sitename)
  # could do more
  # eg. xrdfs 192.170.227.122:1094 query stats a

  # echo "Site is $RESULT. Expected $XC_RESOURCENAME"
  if [ $RESULT == $XC_RESOURCENAME ]; then
    # echo "Sending Rucio heartbeat"
    # echo "needs: $XC_RESOURCENAME, $XC_INSTANCE, $ADDRESS, $size"
    python3 /usr/local/sbin/heartbeat.py $XC_RESOURCENAME $XC_INSTANCE $ADDRESS $size
  else
    echo "Something is wrong."
  fi

  sleep $FREQUENCY
done