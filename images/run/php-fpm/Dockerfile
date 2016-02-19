FROM clamp/lib-php-7:$BUILD_NUMBER
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN apk add --no-cache php7-fpm@testing php7-mysqlnd@testing \
    && mkdir -p /var/run/fpm \
    && ln -sf /dev/stdout /var/log/php7.0-fpm.log \
    && addgroup -S -g 1987 www-data \
    && adduser -S -u 1983 -G www-data www-data

COPY config/ /etc/php7
COPY serve.sh /etc/services.d/php-fpm/run

EXPOSE 9000

VOLUME /var/run/fpm