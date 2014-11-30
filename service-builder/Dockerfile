## -*- docker-image-name: "armbuild/ocs-builder:trusty" -*-
FROM armbuild/ocs-rescue:trusty

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update && \
    apt-get -y -qq upgrade && \
    apt-get install -y -qq \
        debootstrap \
        xz-utils \
    && apt-get clean

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
