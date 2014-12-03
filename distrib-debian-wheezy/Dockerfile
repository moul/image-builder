## -*- docker-image-name: "armbuild/ocs-distrib-debian:wheezy" -*-
FROM armbuild/debian:wheezy
MAINTAINER Online Labs <opensource@ocs.online.net>

 	    	    
# Environment
ENV DEBIAN_FRONTEND noninteractive
# Useful for image inheritance
ENV OCS_BASE_IMAGE armbuild/ocs-debian:wheezy


# Patch rootfs for docker-based builds
RUN apt-get -q update && \
    apt-get -y -qq install wget lsb-release && \
    apt-get clean && \
    wget --no-check-certificate https://codeload.github.com/online-labs/ocs-scripts/tar.gz/master -O /tmp/builder-enter.tgz && \
    tar --strip=2 -C / -xzvf /tmp/builder-enter.tgz ocs-scripts-master/skeleton-docker-based/usr/local/sbin/builder-enter && \
    rm -f /tmp/builder-enter.tgz && \
    /usr/local/sbin/builder-enter


# Install packages
ADD ./patches/etc/apt/sources.list /etc/apt/sources.list
RUN apt-get -q update && \
    apt-get -y -qq upgrade && \
    apt-get install -y -qq \
	bash-completion \
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
	iperf \
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
	python-apt \
	python-yaml \
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
