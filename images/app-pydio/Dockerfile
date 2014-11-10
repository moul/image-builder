FROM armbuild/ocs-ubuntu:utopic

# Prevent init scripts from running during install/update
# policy-rc.d (for most scripts)
RUN echo $'#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install packages
RUN apt-get -q update &&
    apt-get -q upgrade &&
    apt-get install -y -q \
        apache2 \
        libapache2-mod-php5 \
        mysql-server \
        php5 \
        php5-cgi \
        php5-cli \
        php5-curl \
        php5-gd \
        php5-mcrypt \
        php5-mysqlnd \
        pwgen \
    && apt-get clean

# Install Pydio
RUN wget -qO /tmp/pydio.deb http://dl.ajaxplorer.info/repos/apt/pool/main/p/pydio/pydio_5.3.3_all.deb && \
    dpkg -i /tmp/pydio.deb && \
    rm -f /tmp/pydio.deb

# Configues Apache/PHP
RUN a2enmod rewrite && \
    ln -sf /usr/share/doc/pydio/apache2.sample.conf /etc/apache2/sites-enabled/pydio.conf && \
    ln -sf /etc/php5/mods-available/mcrypt.ini /etc/php5/apache2/conf.d/

# Install Pydio dependencies
RUN cd /usr/share/pydio && curl -sS https://getcomposer.org/installer | php && \
    cd /usr/share/pydio && php composer.phar install && \
    wget -qO /usr/share/pydio/aws.phar https://github.com/aws/aws-sdk-php/releases/download/2.7.2/aws.phar

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
