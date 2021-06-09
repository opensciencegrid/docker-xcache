#!/bin/sh

# this is obsolete as CRIC registration is not needed any more

# this script will update state of Service Protocol in AGIS
# usage: ./update-cric-status.sh <protocol_id> <new_status>  
# protocol_id can be seen at the end of the link normally used to edit protocol eg. http://atlas-agis.cern.ch/agis/serviceprotocol/edit/433/
# new_status can be: ACTIVE or DISABLED  

usage () {
    echo "$0 <protocol_id> <new_status>"
    echo "    protocol_id can be seen at the end of the link normally used to edit protocol eg. http://atlas-agis.cern.ch/agis/serviceprotocol/edit/433/"
    echo "    new_status can be: ACTIVE or DISABLED"
}

protocol_id=$1
new_status=$2

if [[ $new_status != "ACTIVE" && $new_status != "DISABLED" ]]; then
    usage
    exit 1
fi

curl -k --cert /etc/grid-certs/usercert.pem \
    --cert-type PEM --key /etc/grid-certs/userkey.pem \
    --key-type PEM \
    "https://atlas-cric.cern.ch/api/core/serviceprotocol/update/set_data/?json&id=$protocol_id&state=$new_status"
