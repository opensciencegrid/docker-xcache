#!/bin/bash

/usr/sbin/setup_xrootd_certs.sh

# Give the chance to the pod to initialize host-specific info
source /usr/sbin/pod_init.sh

# Now we can actually start the supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf

