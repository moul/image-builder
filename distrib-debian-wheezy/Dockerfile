## -*- docker-image-name: "armbuild/ocs-debian:wheezy" -*-
FROM armbuild/debian:wheezy

# Prepare rootfs for image-builder
ADD ./patches/usr/local/sbin/ /usr/local/sbin/
RUN /usr/local/sbin/builder-enter

# Install packages
ADD ./patches/etc/apt/sources.list /etc/apt/sources.list
RUN apt-get -q update && \
    apt-get -q upgrade && \
    apt-get install -y -q \
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
	    libnss-myhostname \
	    locales \
	    locate \
	    lsb-release \
	    lsof \
	    make \
	    mg \
	    mosh \
	    man-db \
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
RUN curl https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | bash
ADD ./patches/ /

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
