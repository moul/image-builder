## -*- docker-image-name: "armbuild/ocs-docker:utopic" -*-
FROM armbuild/ocs-ubuntu:utopic

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update &&  \
    apt-get -q upgrade && \
    apt-get install -y -q \
    	docker.io         \
	bridge-utils      \
    && apt-get clean

RUN wget -O /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && chmod +x /usr/local/bin/pipework

# Patch rootfs
ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
