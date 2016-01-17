FROM clamp/lib-php-7
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN apt-get update \
    && apt-get install -y php-fpm \
    && apt-get clean \
    && phpenmod opcache \
    && phpenmod pdo-mysql \
    && mkdir -p /var/run/fpm \
    && ln -sf /dev/stdout /var/log/php7.0-fpm.log

COPY config/ /etc/php/7.0/fpm
COPY serve.sh /serve.sh

RUN chmod +x /serve.sh

ENTRYPOINT ["/serve.sh"]

VOLUME /var/run/fpm