ARG BUILD_FROM=ghcr.io/hassio-addons/base:latest

FROM ${BUILD_FROM}

ENV LANG=C.UTF-8

RUN apk add --no-cache \
    bash \
    bash-completion \
    openssh \
    openssh-client \
    sudo \
    nano \
    vim \
    htop \
    git \
    curl \
    wget \
    rsync \
    python3 \
    py3-pip \
    tmux \
    zsh

RUN mkdir -p /run/sshd

RUN echo "root:root" | chpasswd

RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]