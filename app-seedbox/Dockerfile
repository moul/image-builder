## -*- docker-image-name: "armbuild/ocs-app-seedbox:utopic" -*-
FROM armbuild/ocs-ubuntu:utopic

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update && \
    apt-get -q upgrade && \
    apt-get install -y -q \
	lvm2 \
	nginx \
	php5-fpm \
	rtorrent \
	screen \
    && apt-get clean

# Patch rootfs
ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
