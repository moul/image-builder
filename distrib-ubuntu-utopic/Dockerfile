## -*- docker-image-name: "armbuild/ocs-ubuntu:utopic" -*-
FROM armbuild/ubuntu-debootstrap:utopic
MAINTAINER Online Labs <opensource@ocs.online.net>

# Environment
ENV DEBIAN_FRONTEND noninteractive
# Useful for image inheritance
ENV OCS_BASE_IMAGE armbuild/ocs-ubuntu:utopic

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
    apt-get -y -qq upgrade && \
    apt-get install -y -qq \
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
        ca-certificates \
    && apt-get clean

# Patch rootfs
# - Add ocs-scripts
# - Tweaks rootfs so it matches Online Labs infrastructure
RUN rm -f /etc/update-motd.d/10-help-text /etc/update-motd.d/00-header
RUN wget -qO - https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | FLAVORS=docker-based,upstart bash
ADD ./patches/etc/ /etc/

# Configure locales
RUN locale-gen en_US.UTF-8 && \
    locale-gen fr_FR.UTF-8 && \
    dpkg-reconfigure locales

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
