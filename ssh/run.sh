#!/usr/bin/with-contenv bashio

set -e

bashio::log.info "Starting SSH server"

if bashio::config.has_value 'password'; then
    PASSWORD=$(bashio::config 'password')
    echo "root:${PASSWORD}" | chpasswd
fi

if bashio::config.has_value 'authorized_keys'; then
    mkdir -p /root/.ssh
    bashio::config 'authorized_keys' > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

/usr/sbin/sshd -D