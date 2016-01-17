FROM clamp/lib-php-7

MAINTAINER Robert Landers <landers.robert@gmail.com>

# Install stuff for composer to work
RUN apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get purge lxc-docker \
    && apt-get install -y docker-engine subversion curl \
    && apt-get clean \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY mkplugin.sh /mkplugin.sh
#COPY config/php.ini /usr/local/etc/php/

RUN chmod +x /mkplugin.sh

ONBUILD RUN /mkplugin $PLUGIN

ENTRYPOINT [ "/mkplugin.sh" ]
