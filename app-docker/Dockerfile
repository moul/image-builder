## -*- docker-image-name: "armbuild/ocs-app-docker:vivid" -*-
FROM armbuild/ocs-distrib-ubuntu:vivid


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update &&  \
    apt-get -q upgrade && \
    apt-get install -y -q \
        bridge-utils      \
        docker.io         \
        fig               \
        python-setuptools \
    && apt-get clean


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/bin/ /usr/bin/
ADD ./patches/usr/local/ /usr/local/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
