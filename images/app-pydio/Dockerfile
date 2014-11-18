## -*- docker-image-name: "armbuild/ocs-app-pydio:utopic" -*-
FROM armbuild/ocs-ubuntu:utopic

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update && \
    apt-get -q upgrade && \
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
ADD ./patches/ /

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
