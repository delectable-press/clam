FROM php:5.6-cli

MAINTAINER Robert Landers <landers.robert@gmail.com>

# Install stuff for composer to work
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get purge lxc-docker \
    && apt-get install -y docker-engine subversion \
    && apt-get clean \
    && apt-get install -y \
               libfreetype6-dev \
               libjpeg62-turbo-dev \
               libmcrypt-dev \
               libpng12-dev \
    && docker-php-ext-install iconv mcrypt mysql opcache zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apt-get clean

COPY mkplugin.sh /mkplugin.sh
#COPY config/php.ini /usr/local/etc/php/

RUN chmod +x /mkplugin.sh

ONBUILD RUN /mkplugin $PLUGIN

ENTRYPOINT [ "/mkplugin.sh" ]
