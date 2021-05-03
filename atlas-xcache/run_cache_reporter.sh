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

/usr/local/sbin/gStream2tcp.py &

while true; do 

  python3 /usr/local/sbin/reporter4.py
  sleep 3600

done