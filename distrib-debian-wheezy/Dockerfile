## -*- docker-image-name: "armbuild/ocs-debian:wheezy" -*-
FROM armbuild/debian:wheezy
MAINTAINER Online Labs <opensource@ocs.online.net>
 	    	    
ENV DEBIAN_FRONTEND noninteractive
ENV OCS_BASE_IMAGE armbuild/ocs-debian:wheezy

# Patch rootfs for docker-based builds
RUN apt-get -q update && \
    apt-get -y -qq install wget && \
    apt-get clean && \
    mkdir -p /usr/local/sbin && \
    wget -q https://raw.githubusercontent.com/online-labs/ocs-scripts/master/skeleton-docker-based/usr/local/sbin/builder-enter -O /usr/local/sbin/builder-enter && \
    chmod +x /usr/local/sbin/builder-enter && \
    /usr/local/sbin/builder-enter


# Install packages
ADD ./patches/etc/apt/sources.list /etc/apt/sources.list
RUN apt-get -q update && \
    apt-get -q upgrade && \
    apt-get install -y -q \
	ca-certificates \
	cron \
	curl \
	dbus \
	dstat \
	ethstatus \
	file \
	fio \
	htop \
	ioping \
	iotop \
	iptables \
	iputils-ping \
	isc-dhcp-client \
	less \
	libnss-myhostname \
	locales \
	locate \
	lsb-release \
	lsof \
	make \
	man-db \
	mg \
	mosh \
	nano \
	nbd-client \
	net-tools \
	netcat \
	ntp \
	ntpdate \
	rsync \
	rsyslog \
	screen \
	socat \
	ssh \
	sudo \
	sysstat \
	tcpdump \
	tmux \
	vim \
	wget \
	whiptail \
	xnbd-client \
    && apt-get clean

# Patch rootfs
# - Add ocs-scripts
# - Tweaks rootfs so it matches Online Labs infrastructure
RUN wget -qO - https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | FLAVORS=docker-based,sysvinit bash
RUN rm -f /etc/motd && ln -s /var/run/motd /etc/motd
ADD ./patches/etc/ /etc/

# Configure locales
RUN locale-gen

# Configure SysV
RUN update-rc.d ssh-keys defaults && \
    update-rc.d sync-kernel-modules defaults && \
    update-rc.d nbd-root-disconnect defaults && \
    update-rc.d nbd-add-extra-volumes defaults && \
    update-rc.d oc-force-dhclient defaults

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
