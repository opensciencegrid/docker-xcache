#!/bin/sh

size=`df -l | grep xcache/data | awk '{sum+=$2;} END{print sum;}'`

while true; do 
  date

  echo 'checking xcache'
  
  RESULT=$(xrdfs 192.170.227.122:1094 query config sitename)
  # could do more
  # eg. xrdfs 192.170.227.122:1094 query stats a
  
  echo "Site is $RESULT. Expected $XC_RESOURCENAME"
  if [ $RESULT == $XC_RESOURCENAME ]; then
    echo "Sending Rucio heartbeat"
    echo "needs: $XC_RESOURCENAME, $XC_INSTANCE, $ADDRESS, $size"
    # send Rucio heartbeat.
    # --cert /etc/grid-certs/usercert.pem \
    # --cert-type PEM --key /etc/grid-certs/userkey.pem \
  else
    echo "Something is wrong."
  fi

  sleep $FREQUENCY
done