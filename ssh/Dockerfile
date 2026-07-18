ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.2.2
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV TERM="xterm-256color"

COPY requirements.txt /tmp/

ARG BUILD_ARCH=armv7
ARG HA_CLI_VERSION="4.29.0"
ARG TTYD_VERSION="1.7.4"

RUN \
    apk add --no-cache --virtual .build-dependencies \
        bsd-compat-headers \
        build-base \
        cmake \
        docker \
        json-c-dev \
        libffi-dev \
        libuv-dev \
        openssl-dev \
        python3-dev \
        zlib-dev \
    \
    && apk add --no-cache \
        ack \
        alsa-plugins-pulse \
        alsa-utils \
        awake \
        bash-completion \
        bind-tools \
        bluez \
        colordiff \
        docker-bash-completion \
        docker-zsh-completion \
        gcompat \
        git \
        htop \
        json-c \
        libltdl \
        libstdc++ \
        libuv \
        libxml2-utils \
        mariadb-client \
        mosh \
        mosquitto-clients \
        nano \
        nano-syntax \
        ncurses \
        net-tools \
        networkmanager-cli \
        nmap \
        openssh \
        openssl \
        pwgen \
        pulseaudio-utils \
        py3-pip \
        python3 \
        rsync \
        sqlite \
        sudo \
        tmux \
        vim \
        wget \
        zip \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
    \
    && git clone --depth 1 \
        https://github.com/robbyrussell/oh-my-zsh.git \
        /root/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_${BUILD_ARCH}" \
    \
    && chmod a+x /usr/bin/ha \
    && ha completion bash > /usr/share/bash-completion/completions/ha \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch v4.3.2 --depth=1 \
        https://github.com/warmcat/libwebsockets.git \
        /tmp/libwebsockets \
    \
    && mkdir /tmp/libwebsockets/build \
    && cd /tmp/libwebsockets/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DLWS_IPV6=ON \
        -DLWS_STATIC_PIC=ON \
        -DLWS_UNIX_SOCK=OFF \
        -DLWS_WITH_LIBUV=ON \
        -DLWS_WITH_SHARED=ON \
        -DLWS_WITHOUT_TESTAPPS=ON \
    && make \
    && make install \
    \
    && git clone --branch main --single-branch \
        https://github.com/tsl0922/ttyd.git \
        /tmp/ttyd \
    && git -C /tmp/ttyd checkout "${TTYD_VERSION}" \
    \
    && mkdir /tmp/ttyd/build \
    && cd /tmp/ttyd/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
    && make \
    && make install \
    \
    && cp /usr/bin/docker /usr/local/bin/.undocked \
    \
    && pip3 install -r /tmp/requirements.txt \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && find /usr \
        \( -type d -a -name test -o -name tests -o -name '__pycache__' \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    \
    && rm -rf \
        /root/.cache \
        /root/.cmake \
        /tmp/*


COPY rootfs /

RUN \
    chmod 0750 /etc/sudo.conf \
    && chmod 0750 -R /etc/sudoers.d \
    && chmod 0640 /etc/sudoers.d


ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Home Assistant Community Add-ons" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"