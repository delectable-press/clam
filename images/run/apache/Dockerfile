FROM ubuntu:14.04
MAINTAINER Rob Landers <landers.robert@gmail.com>
VOLUME /var/www/html
RUN echo \
    && echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get install -y \
        php5 \
        php5-xdebug \
        php5-memcached \
        php5-mcrypt \
        php5-mysql \
        php5-gd \
        php5-curl \
        apache2 \
    && apt-get clean

RUN a2enmod rewrite \
    && ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
    && ln -sf /proc/self/fd/1 /var/log/apache2/error.log

COPY config/php.ini /etc/php5/apache2/php.ini

ENV APACHE_LOCK_DIR=/tmp APACHE_PID_FILE=/tmp/apache.pid APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR=/var/log/apache2

ENTRYPOINT ["apache2", "-DFOREGROUND", "-e", "info"]