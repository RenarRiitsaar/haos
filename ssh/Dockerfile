ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG HA_CLI_VERSION=4.29.0
ARG TTYD_VERSION=1.7.4

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
        https://github.com/ohmyzsh/ohmyzsh.git \
        /root/.oh-my-zsh \
    \
    && curl -L -s -o /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_${BUILD_ARCH}" \
    \
    && chmod +x /usr/bin/ha \
    \
    && ha completion bash > \
        /usr/share/bash-completion/completions/ha \
    \
    && sed -i "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch v4.3.2 --depth=1 \
        https://github.com/warmcat/libwebsockets.git \
        /tmp/libwebsockets \
    \
    && mkdir /tmp/libwebsockets/build \
    && cd /tmp/libwebsockets/build \
    \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DLWS_IPV6=ON \
        -DLWS_WITH_LIBUV=ON \
        -DLWS_WITH_SHARED=ON \
        -DLWS_WITHOUT_TESTAPPS=ON \
    \
    && make -j$(nproc) \
    && make install \
    \
    && git clone --branch main --single-branch \
        https://github.com/tsl0922/ttyd.git \
        /tmp/ttyd \
    \
    && git -C /tmp/ttyd checkout ${TTYD_VERSION} \
    \
    && mkdir /tmp/ttyd/build \
    && cd /tmp/ttyd/build \
    \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
    \
    && make -j$(nproc) \
    && make install \
    \
    && cp /usr/bin/docker /usr/local/bin/.undocked \
    \
    && pip3 install --no-cache-dir -r /tmp/requirements.txt \
    \
    && apk del --no-cache .build-dependencies \
    \
    && rm -rf \
        /root/.cache \
        /root/.cmake \
        /tmp/*


