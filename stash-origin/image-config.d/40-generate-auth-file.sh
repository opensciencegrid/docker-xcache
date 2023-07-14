#!/bin/bash -x

dump_files () {
    local containing_dir
        shopt -s nullglob
        for f in "$containing_dir"/*; do
            echo "======= $f ======="
            cat "$f"
            echo
        done
        shopt -u nullglob
}

# Generate the Authfiles and scitokens.conf file
if supervisord_is_enabled stash-origin; then
    /usr/libexec/xcache/authfile-update stash-origin
    [[ "$?" -ne 0 ]] && dump_files /run/stash-origin
fi
if supervisord_is_enabled stash-origin-auth ||
        supervisord_is_enabled stash-origin-auth-privileged; then
    /usr/libexec/xcache/authfile-update stash-origin-auth
    [[ "$?" -ne 0 ]] && dump_files /run/stash-origin-auth
fi


shopt -s nullglob
for f in /run/stash-origin/* /run/stash-origin-auth/*; do
    chown xrootd:xrootd "$f"
done
shopt -u nullglob

# ddavila 20220225: Save the env var ORIGIN_FQDN to be used
# later by 'xrootd' on the 'authfile-update' script.
echo "# This file was generated on startup" > /etc/xrootd-environment

if [[ -n ${ORIGIN_FQDN} ]]; then
        echo "export ORIGIN_FQDN=${ORIGIN_FQDN}" >> /etc/xrootd-environment
fi
chown xrootd:xrootd /etc/xrootd-environment
