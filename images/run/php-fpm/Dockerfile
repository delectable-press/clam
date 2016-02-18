FROM clamp/lib-php-7:$BUILD_NUMBER
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN apt-get-install-min php-fpm \
    && phpenmod opcache \
    && phpenmod pdo-mysql \
    && mkdir -p /var/run/fpm \
    && ln -sf /dev/stdout /var/log/php7.0-fpm.log

COPY config/ /etc/php/7.0/fpm
COPY serve.sh /etc/services.d/php-fpm/run

EXPOSE 9000

VOLUME /var/run/fpm