#!/bin/sh

size=`df -l | grep xcache/data | awk '{sum+=$2;} END{print sum;}'`

while true; do 
  date
  rucio whoami

  echo 'checking xcache'
  
  # change to actual server address.
  RESULT=$(xrdfs $ADDRESS query config sitename)
  # could do more
  # eg. xrdfs 192.170.227.122:1094 query stats a

  echo "Site is $RESULT. Expected $XC_RESOURCENAME"
  if [ $RESULT == $XC_RESOURCENAME ]; then
    echo "Sending Rucio heartbeat"
    echo "needs: $XC_RESOURCENAME, $XC_INSTANCE, $ADDRESS, $size"
    python3 /usr/local/sbin/heartbeat.py $XC_RESOURCENAME, $XC_INSTANCE, $ADDRESS, $size
  else
    echo "Something is wrong."
  fi

  sleep $FREQUENCY
done