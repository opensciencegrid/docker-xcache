if [[ ${NO_RSYSLOG:-0} == 1 ]]; then
    rm -f "/etc/supervisord.d/00-rsyslogd.conf"
fi
