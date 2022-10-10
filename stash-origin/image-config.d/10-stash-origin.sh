#!/bin/bash
if [ -f /etc/grid-security/hostcert.pem ]; then
  /usr/local/sbin/fix_certs.sh
fi

# For the stash-origin image, whether the xrootd and cmsd instances for
# stash-origin, stash-origin-auth, or both, are selected by environment
# variables.

# supervisord_... functions are defined in xcache/image-config.d/00-functions.sh

# declare these if missing
: "${XC_AUTH_ORIGIN_EXPORT=} ${XC_PUBLIC_ORIGIN_EXPORT=} ${XC_ORIGINEXPORT=}"

if [[ $XC_AUTH_ORIGIN_EXPORT ]]; then
  supervisord_enable stash-origin-auth
  supervisord_enable stash-origin-auth-cmsd
else
  supervisord_disable stash-origin-auth
  supervisord_disable stash-origin-auth-cmsd
fi
if [[ $XC_PUBLIC_ORIGIN_EXPORT || $XC_ORIGINEXPORT ]]; then
  supervisord_enable stash-origin
  supervisord_enable stash-origin-cmsd
elif [[ $XC_AUTH_ORIGIN_EXPORT ]]; then
  # we're starting an auth instance only
  supervisord_disable stash-origin
  supervisord_disable stash-origin-cmsd
else
  # backward compat: none of the three variables are defined so start an unauth
  # instance (exporting the default path)
  supervisord_enable stash-origin
  supervisord_enable stash-origin-cmsd
fi
