#!/usr/bin/with-contenv bashio

set -e

bashio::log.info "Starting SSH server"

# Generate SSH host keys if missing
ssh-keygen -A

if bashio::config.has_value 'password'; then
    PASSWORD=$(bashio::config 'password')
    echo "root:${PASSWORD}" | chpasswd
fi

if bashio::config.has_value 'authorized_keys'; then
    mkdir -p /root/.ssh
    bashio::config 'authorized_keys' > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

exec /usr/sbin/sshd -D