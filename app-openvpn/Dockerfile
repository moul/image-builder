## -*- docker-image-name: "armbuild/ocs-app-openvpn:utopic" -*-
FROM armbuild/ocs-distrib-ubuntu:utopic

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update && \
    apt-get -q upgrade && \
    apt-get install -y -q \
	curl \
	iptables \
	iptables-persistent \
    	openvpn \
	uuid \
    && apt-get clean

# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/local/ /usr/local/

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
