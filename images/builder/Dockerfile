## -*- docker-image-name: "armbuild/ocs-builder:trusty" -*-
FROM armbuild/ocs-rescue:trusty

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update &&  \
    apt-get -q upgrade && \
    apt-get install -y -q \
        debootstrap       \
        xz-utils          \
    && apt-get clean

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
