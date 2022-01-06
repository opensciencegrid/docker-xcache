#!/bin/sh

# This one has the data volume mounted and periodically collect information from
# .cinfo files, aggregate it and report to ES.

COUNTER=0
for dir in /xcache/data_*
do
    echo "Found ${dir}."
    let COUNTER=COUNTER+1
    echo "exporting it as DISK_${COUNTER}"
    export DISK_${COUNTER}=${dir}
done

/usr/local/sbin/stats.py &
spid=$!

/usr/local/sbin/gStream2tcp.py &
gpid=$!

while true; do 
  date

  ps $spid
  if [[ $? -ne 0 ]]; then
    echo Statistic collection died.
    break
  fi
  
  ps $gpid
  if [[ $? -ne 0 ]]; then
    echo gStream collection died.
    break
  fi

  sleep 3600
done