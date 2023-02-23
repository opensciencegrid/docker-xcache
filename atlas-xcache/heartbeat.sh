#!/bin/sh

# this script will sends heartbeats to a service listening for them

usage () {
    echo "$0 <service endpoint> <xcache site name> <xcache instance ID> <xcache IP>"
    echo "   <service endpoint> service receiving heartbeat. it listens for a POST request."
    echo "   <xcache site name> site where xcache is deployed."
    echo "   <xcache instance ID> this uniquely identifies xcache server."
    echo "   <xcache IP> externally accessible IP where xcache serves."
}

if [ $# -lt 4 ]; then
    usage
    exit 1
fi

service=$1
site=$2
instanceID=$3
address=$4
size=`df -l | grep xcache/data | awk '{sum+=$2;} END{print sum;}'`

echo $service $site $instanceID $address $size
curl --request POST "$service" \
    -k \
    --connect-timeout 5 \
    --max-time 7 \
    --header 'Content-Type: application/json' \
    --data "{\"site\":\"$site\",\"id\":\"$instanceID\",\"address\":\"$address\",\"size\":\"$size\"}"

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "heartbeat sent"
else
  echo "heartbeat could not be sent"
fi

exit 0