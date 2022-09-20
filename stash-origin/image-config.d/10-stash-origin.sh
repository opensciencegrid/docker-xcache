#!/bin/bash
if [ -f /etc/grid-security/hostcert.pem ]; then
  /usr/local/sbin/fix_certs.sh
fi

# For the stash-origin image, whether the xrootd and cmsd instances for
# stash-origin, stash-origin-auth, or both, are selected by environment
# variables.

# supervisord_... functions are defined in xcache/image-config.d/00-functions.sh

if /usr/local/bin/pkg-cmp-gt.sh xcache 3.2.0 && [[ -n ${XC_AUTH_ORIGIN_EXPORT:-} ]]; then
  supervisord_enable stash-origin-auth
  supervisord_enable stash-origin-auth-cmsd
else
  supervisord_disable stash-origin-auth
  supervisord_disable stash-origin-auth-cmsd
fi
if [[ -n ${XC_PUBLIC_ORIGIN_EXPORT:-} || -n ${XC_ORIGINEXPORT:-} ]]; then
  supervisord_enable stash-origin
  supervisord_enable stash-origin-cmsd
else
  supervisord_disable stash-origin
  supervisord_disable stash-origin-cmsd
fi
# backward compat:
if [[ -z ${XC_AUTH_ORIGIN_EXPORT:-} && -z ${XC_PUBLIC_ORIGIN_EXPORT:-} && -z ${XC_ORIGINEXPORT:-} ]]; then
  supervisord_enable stash-origin
  supervisord_enable stash-origin-cmsd
fi
