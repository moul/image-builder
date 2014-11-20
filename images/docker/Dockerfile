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
	python-setuptools \
    && apt-get clean

# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework

# Install Gosu
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf && \
    chmod +x /usr/local/bin/gosu

ADD ./fig.egg /tmp/
RUN easy_install /tmp/fig.egg && \
    rm -f /tmp/fig.egg

# Patch rootfs
#ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
