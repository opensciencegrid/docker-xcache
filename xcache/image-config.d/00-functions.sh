supervisord_enable () {
    local service="$1"
    if [[ -e /etc/supervisord.d/${service}.conf.disabled ]]; then
        mv /etc/supervisord.d/${service}.conf.disabled /etc/supervisord.d/${service}.conf
    fi
}

supervisord_disable () {
    local service="$1"
    if [[ -e /etc/supervisord.d/${service}.conf ]]; then
        mv /etc/supervisord.d/${service}.conf /etc/supervisord.d/${service}.conf.disabled
    fi
}
