FROM armbuild/ocs-docker:latest

# Prevent init scripts from running during install/update
# policy-rc.d (for most scripts)
RUN echo $'#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install packages
RUN apt-get -q update &&
    apt-get -q upgrade &&
    apt-get install -y -q \
        nodejs \
	npm \
	make \
	g++ \
    && apt-get clean

# Fix paths
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install TTY.js
RUN npm install -g tty.js

# Create ubuntu user
RUN seradd -G sudo -s /bin/bash -m ubuntu

# Remove password for sudo
RUN sed -i '/sudo/s/ALL)/ALL) NOPASSWD:/' /etc/sudoer

# Patch rootfs
# - Add ocs-scripts
# - Tweaks rootfs so it matches Online Labs infrastructure
# RUN curl https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | bash
ADD ./patches/ /

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
