## -*- docker-image-name: "armbuild/ocs-service-rescue:trusty" -*-
FROM armbuild/ocs-distrib-ubuntu:trusty

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update && \
    apt-get -q upgrade && \
    apt-get install -y -q \
	    busybox \
	    ethstatus \
	    htop \
	    iperf \
	    lsof \
	    lvm2 \
	    memtester \
	    parted \
	    partimage \
	    rsync \
	    socat \
	    tcpdump \
	    traceroute \
    	    iotop \
    && apt-get clean

# Patch rootfs
ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
