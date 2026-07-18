ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG HA_CLI_VERSION=4.29.0
ARG TTYD_VERSION=1.7.4

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3003,DL3042
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
        ca-certificates \
        colordiff \
        curl \
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
    && update-ca-certificates \
    \
    && git clone --depth 1 \
        https://github.com/ohmyzsh/ohmyzsh.git \
        /root/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_${BUILD_ARCH}" \
    \
    && chmod a+x /usr/bin/ha \
    \
    && ha completion bash > \
        /usr/share/bash-completion/completions/ha \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch "v4.3.2" --depth=1 \
        https://github.com/warmcat/libwebsockets.git \
        /tmp/libwebsockets \
    \
    && mkdir -p /tmp/libwebsockets/build \
    \
    && cd /tmp/libwebsockets/build \
    \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DLWS_IPV6=ON \
        -DLWS_STATIC_PIC=ON \
        -DLWS_UNIX_SOCK=OFF \
        -DLWS_WITH_LIBUV=ON \
        -DLWS_WITH_SHARED=ON \
        -DLWS_WITHOUT_TESTAPPS=ON \
    \
    && make -j"$(nproc)" \
    && make install \
    \
    && git clone \
        --branch "${TTYD_VERSION}" \
        --depth=1 \
        https://github.com/tsl0922/ttyd.git \
        /tmp/ttyd \
    \
    && mkdir -p /tmp/ttyd/build \
    \
    && cd /tmp/ttyd/build \
    \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
    \
    && make -j"$(nproc)" \
    && make install \
    \
    && cp /usr/bin/docker /usr/local/bin/.undocked \
    \
    && pip3 install \
        --no-cache-dir \
        --break-system-packages \
        -r /tmp/requirements.txt \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && find /usr \
        \( -type d -a -name test -o -name tests -o -name '__pycache__' \) \
        -o \
        \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    \
    && rm -rf \
        /root/.cache \
        /root/.cmake \
        /tmp/*

