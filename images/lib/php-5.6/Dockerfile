FROM ubuntu:14.04
MAINTAINER Rob Landers <landers.robert@gmail.com>

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
    && apt-get clean