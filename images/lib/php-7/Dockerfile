FROM clamp/lib-base
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN echo \
    && echo "deb http://ppa.launchpad.net/ondrej/php-7.0/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php7_0-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update \
    && apt-get install -y \
        php7.0 \
        php-memcached \
        php-mcrypt \
        php-mysql \
        php-gd \
        php-curl \
    && apt-get purge -y apache2 apache2-bin apache2-data \
    && apt-get autoremove -y \
    && apt-get clean