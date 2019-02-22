#!/bin/bash

# Allow the derived images to run any additional runtime customizations
source /usr/local/sbin/xcache_image_init.sh

# Give the chance to the pod to initialize host-specific info
source /usr/local/sbin/xcache_pod_init.sh

# Now we can actually start the supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf

