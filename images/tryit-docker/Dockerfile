## -*- docker-image-name: "armbuild/ocs-tryit-docker:utopic" -*-
FROM armbuild/ocs-docker:utopic

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update &&  \
    apt-get -q upgrade && \
    apt-get install -y -q \
        nodejs            \
	npm               \
	make              \
	g++               \
    && apt-get clean

# Fix paths
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install TTY.js
RUN npm install -g tty.js

# Create ubuntu user
RUN useradd -G sudo -s /bin/bash -m ubuntu

# Remove password for sudo
RUN sed -i '/sudo/s/ALL)/ALL) NOPASSWD:/' /etc/sudoers

# Patch rootfs
ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
