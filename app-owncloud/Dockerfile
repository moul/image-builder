## -*- docker-image-name: "armbuild/ocs-app-owncloud:trusty" -*-
FROM armbuild/ocs-ubuntu:trusty

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update && \
    apt-get -q upgrade && \
    apt-get install -y -q \
	mysql-server \
	pwgen \
    && apt-get install --no-install-recommends -y -q \
        owncloud \
    && apt-get clean

# Configure Apache
RUN a2enmod rewrite

# Patch rootfs
ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
