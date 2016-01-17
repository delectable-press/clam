FROM clamp/lib-php-7
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN apt-get update \
    && apt-get install -y php-fpm \
    && apt-get clean \
    && phpenmod opcache

VOLUME /var/run/fpm