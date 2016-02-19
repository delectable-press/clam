FROM clamp/lib-php-7:0.2.0

MAINTAINER Robert Landers <landers.robert@gmail.com>

# Install stuff for composer to work
RUN apt-get-install-min apt-transport-https \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get purge lxc-docker \
    && apt-get install -y docker-engine subversion curl \
    && apt-get clean \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV plugin=""
ENV others=""

COPY mkplugin.sh /etc/services.d/builder/run
COPY stop.sh /etc/services.d/builder/finish

ONBUILD RUN /mkplugin $PLUGIN