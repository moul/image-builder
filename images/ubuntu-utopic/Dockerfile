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
	lsof \
	make \
	man-db \
	nano \
	nbd-client \
	net-tools \
	netcat \
	ntp \
	ntpdate \
	rsyslog \
	screen \
	socat \
	ssh \
	sudo \
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
RUN curl https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | bash
ADD ./patches/ /

# Configure locales
RUN locale-gen en_US.UTF-8 && \
    locale-gen fr_FR.UTF-8 && \
    dpkg-reconfigure locales

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
