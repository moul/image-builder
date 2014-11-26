## -*- docker-image-name: "armbuild/ocs-docker:utopic" -*-
FROM armbuild/ocs-ubuntu:utopic


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update &&  \
    apt-get -q upgrade && \
    apt-get install -y -q \
	bridge-utils      \
	python-setuptools \
    && apt-get clean


# Install docker
RUN apt-get -y -q install libapparmor1 libdevmapper1.02.1 && apt-get clean && \
    wget -qO /tmp/docker-1.3.2.deb http://ftp.fr.debian.org/debian/pool/main/d/docker.io/docker.io_1.3.2~dfsg1-1_armhf.deb && \
    dpkg --force-all -i /tmp/docker-1.3.2.deb && \
    rm -f /tmp/docker-1.3.2.deb


# Install fig
ADD ./sources/fig.egg /tmp/
RUN easy_install /tmp/fig.egg && \
    rm -f /tmp/fig.egg


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.2/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Patch rootfs
ADD ./patches/ /


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
