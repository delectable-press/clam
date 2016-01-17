FROM clamp/lib-php-7
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN apt-get update \
    && apt-get install -y php-fpm \
    && apt-get clean \
    && phpenmod opcache \
    && mkdir -p /var/run/fpm \
    && ln -sf /dev/stdout /var/log/php7.0-fpm.log

ENTRYPOINT ["/usr/sbin/php-fpm7.0", "-F"]

VOLUME /var/run/fpm