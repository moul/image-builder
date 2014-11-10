FROM armbuild/debian-debootstrap:wheezy

# Prevent init scripts from running during install/update
# policy-rc.d (for most scripts)
RUN echo $'#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install packages
ADD ./patches/etc/apt/sources.list /etc/apt/sources.list
RUN apt-get -q update &&
    apt-get -q upgrade &&
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
RUN locale-gen

# Configure SysV
RUN update-rc.d ssh-keys defaults && \
    update-rc.d sync-kernel-modules defaults && \
    update-rc.d nbd-root-disconnect defaults && \
    update-rc.d nbd-add-extra-volumes defaults && \
    update-rc.d oc-force-dhclient defaults

# Clean
# - make image smaller
# - remove ssh host keys so they are regenerated on first boot
# - remove /etc/hostname and resolv.conf that contains build information and will be regenerated using from dhcp
# - Remove hacks
#   - Prevent init scripts from running during install/update
RUN
    rm -f \
	/etc/hostname \
	/etc/resolv.conf \
	/etc/ssh/*_key* \
	/root/.history \
	/var/cache/apt/*.bin
	/var/cache/apt/archives/partial/*.deb \
	/var/log/bootstrap.log \
        /root/.bash_history \
        /usr/sbin/policy-rc.d \
        /var/cache/apt/archives/*.deb \
    && apt-get clean

# Update locate cache
RUN updatedb

# Update aptitude cache
RUN apt-get update
