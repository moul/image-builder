## -*- docker-image-name: "armbuild/ocs-ubuntu:utopic" -*-
FROM armbuild/ubuntu-debootstrap:utopic

# Prepare rootfs for image-builder
ADD ./patches/usr/local/sbin/ /usr/local/sbin/
RUN /usr/local/sbin/builder-enter

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
RUN wget -qO - https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | FLAVORS=upstart bash
RUN rm -f /etc/update-motd.d/10-help-text /etc/update-motd.d/00-header
ADD ./patches/ /

# Configure locales
RUN locale-gen en_US.UTF-8 && \
    locale-gen fr_FR.UTF-8 && \
    dpkg-reconfigure locales

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
