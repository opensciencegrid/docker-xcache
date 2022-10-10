supervisord_is_enabled () {
    local service="$1"
    [[ -e /etc/supervisord.d/${service}.conf ]]
}


supervisord_is_disabled () {
    local service="$1"
    [[ -e /etc/supervisord.d/${service}.conf.disabled ]]
}


supervisord_enable () {
    local service="$1"
    if supervisord_is_disabled ${service}; then
        mv -f /etc/supervisord.d/${service}.conf{.disabled,}
    fi
}

supervisord_disable () {
    local service="$1"
    if supervisord_is_enabled ${service}; then
        mv -f /etc/supervisord.d/${service}.conf{,.disabled}
    fi
}
