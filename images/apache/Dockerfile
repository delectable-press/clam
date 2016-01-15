FROM php:5.6-apache
MAINTAINER Rob Landers <landers.robert@gmail.com>
VOLUME /var/www/html
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        php5-xdebug \
    && docker-php-ext-install iconv mcrypt mysql opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN a2enmod rewrite

COPY config/php.ini /usr/local/etc/php/