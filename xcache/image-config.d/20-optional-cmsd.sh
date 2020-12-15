#!/bin/bash

if [[ -n $XC_REDIRECTOR_FQDN ]] &&
       [[ -n $XC_REDIRECTOR_PORT ]] &&
       [[ $XC_IMAGE_NAME != 'stash-origin' ]]; then
    cat <<EOF > /etc/supervisord.d/10-xcache-cmsd.conf
[program:xcache-cmsd]
command=/usr/bin/cmsd -c /etc/xrootd/xrootd-%(ENV_XC_IMAGE_NAME).cfg -k fifo -n %(ENV_XC_IMAGE_NAME) -k %(ENV_XC_NUM_LOGROTATE)s -s /var/run/xrootd/cmsd-%(ENV_XC_IMAGE_NAME).pid -l /var/log/xrootd/cmsd.log
user=xrootd
autorestart=true
environment=LD_PRELOAD=/usr/lib64/libtcmalloc.so,TCMALLOC_RELEASE_RATE=10
EOF
fi
