#!/bin/sh

# this script will sends heartbeats to a service listening for them

usage () {
    echo "$0 <service endpoint> <xcache site name> <xcache instance ID> <xcache IP> [size]"
    echo "   <service endpoint> service receiving heartbeat. it listens for a POST request."
    echo "   <xcache site name> site where xcache is deployed."
    echo "   <xcache instance ID> this uniquely identifies xcache server."
    echo "   <xcache IP> externally accessible IP where xcache serves."
    echo "   [size] total disk size dedicated to xcache. In Bytes."
}

if [ $# -lt 4 ]; then
    usage
    exit 1
fi

service=$1
site=$2
instanceID=$3
address=$4
size=$5

curl --request POST "$service" \
    --header 'Content-Type: application/json' \
    --data "{\"site\":\"$site\",\"id\":\"$instanceID\",\"address\":\"$address\",\"size\":\"$size\"}"